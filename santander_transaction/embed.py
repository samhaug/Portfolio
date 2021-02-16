import torch
from sklearn import metrics
import torch.nn as nn
from tqdm import tqdm
from dataset import get_data
from torch.utils.data import DataLoader
import torch.nn.functional as  F

'''
Features are uncorrelated, do a continuous embedding on the input values. 
This has the neural network find a lower-dimensional representation of the 
data.
'''

DEVICE = 'cuda' if torch.cuda.is_available() else 'cpu'

class NN(nn.Module):
    def __init__(self, input_size, hidden_dim):
        super(NN, self).__init__()
        self.bn = nn.BatchNorm1d(input_size)
        self.fc1 = nn.Linear(1, hidden_dim)
        self.fc2 = nn.Linear(input_size*hidden_dim, 1)

    def forward(self, x):
        BATCH_SIZE = x.shape[0]
        x = self.bn(x) #(BATCH_SIZE, 200)
        # Unravel batch to be one string of numbers
        x = x.view(-1, 1) #(BATCH_SIZE*200, 1)
        # Use linear layer as dimensionality reduction
        x = F.relu(self.fc1(x)).reshape(BATCH_SIZE, -1)
        # manually apply sigmoid because using BCELoss
        return torch.sigmoid(self.fc2(x)).view(-1, 1)

def get_predictions(loader, model, device):
    model.eval()
    saved_preds = []
    true_labels = []
    with torch.no_grad():
        for x,y in loader:
            x = x.to(device)
            y = y.to(device)
            scores = model(x)
            saved_preds += scores.tolist()
            true_labels += y.tolist()
    model.train()

    return saved_preds, true_labels

model = NN(input_size=200, hidden_dim=16).to(DEVICE)
train_ds, val_ds, test_ds, test_ids = get_data()

optimizer = torch.optim.Adam(model.parameters(), lr=3e-4, weight_decay=1e-4)
loss_fn = nn.BCELoss()
train_loader = DataLoader(train_ds, batch_size=1024, shuffle=True)
val_loader = DataLoader(val_ds, batch_size=1024)
test_loader = DataLoader(test_ds, batch_size=1024)

x, y = next(iter(train_loader))
print(x.shape)

for epoch in range(20):
    probs, true = get_predictions(val_loader, model, DEVICE)
    val_roc = metrics.roc_auc_score(true, probs)
    probs, true = get_predictions(train_loader, model, DEVICE)
    train_roc = metrics.roc_auc_score(true, probs)
    print("TRAIN/VAL ROC: %8.4f %8.4f"%(train_roc,val_roc))

    for batch_idx, (data, targets) in enumerate(train_loader):
        model.train()
        data = data.to(DEVICE)
        targets = targets.to(DEVICE)

        scores = model(data)
        loss = loss_fn(scores, targets)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()



