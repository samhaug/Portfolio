import torch
from sklearn import metrics
import torch.nn as nn
from tqdm import tqdm
from dataset import get_data
from torch.utils.data import DataLoader

'''
Do simple neural network to get a baseline performace
'''


DEVICE = 'cuda' if torch.cuda.is_available() else 'cpu'

class NN(nn.Module):
    def __init__(self, input_size):
        super(NN, self).__init__()
        self.net = nn.Sequential(
                nn.BatchNorm1d(input_size),
                nn.Linear(input_size, 50),
                nn.ReLU(inplace=True),
                nn.Linear(50, 1),
        )

    def forward(self, x):
        # Put output through sigmoid and use BCELoss
        return torch.sigmoid(self.net(x))

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

model = NN(input_size=200)
model.to(DEVICE)
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
    print("VALIDATION ROC: %8.3f"%metrics.roc_auc_score(true, probs))

    for batch_idx, (data, targets) in enumerate(train_loader):
        model.train()
        data = data.to(DEVICE)
        targets = targets.to(DEVICE)

        scores = model(data)
        loss = loss_fn(scores, targets)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()



