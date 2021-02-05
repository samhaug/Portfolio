import torch
import torchvision
from   torchvision import transforms
import copy
import torch.nn as nn
import numpy as np
import pandas as pd
import time
from   tqdm import tqdm
from   PIL import Image, ImageFile
from   torch.utils.data import Dataset
import os
from torchvision import models
from matplotlib import pyplot as plt

device = ('cuda' if torch.cuda.is_available() else 'cpu')
print("Using device :", device)
ImageFile.LOAD_TRUNCATED_IMAGES = True

num_classes = 5
batch_size = 5
num_epochs = 10
feature_extract = True

#Use this to work on google drive
drive_str = '/content/drive/MyDrive/colab/'

#Use this to work on local machine
#drive_str = './'

class RetinopathyDatasetTrain(Dataset):
    '''
    Dataset object to load training data
    '''
    def __init__(self, csv_file, transform):
        self.data = pd.read_csv(csv_file)
        self.transform = transform

    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        img_name = os.path.join(drive_str+'train_images',
                self.data.loc[idx, 'id_code']+'.png')
        image = Image.open(img_name)
        image = self.transform(image)
        label = self.data.loc[idx, 'diagnosis']
        return image, label

class RetinopathyDatasetTest(Dataset):
    '''
    Dataset object to load test
    '''

    def __init__(self, csv_file, transform):
        self.data = pd.read_csv(csv_file)
        self.transform = transform

    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        img_name = os.path.join(drive_str+'test_images',
                self.data.loc[idx, 'id_code']+'.png')
        image = Image.open(img_name)
        image = self.transform(image)
        return image

def train_single_batch(model, optimizer, criterion, data_loader, num_epochs):
    '''
    Run to make sure the model can overfit one batch from the 
    training set before training multiple epochs
    '''
    image, label = next(iter(data_loader))
    image, label = image.to(device), label.to(device)
    
    since = time.time()
    for i in range(num_epochs):
        optimizer.zero_grad()
        output = model(image)
        loss = criterion(output, label)
        loss.backward()
        print(loss)
        optimizer.step()
    time_elapsed = time.time() - since
    print("Time: %8.3f"%time_elapsed)

def train_model(model, dataloaders, criterion, optimizer, num_epochs):

    since = time.time()
    val_acc_history = []
    best_model_wts = copy.deepcopy(model.state_dict())
    best_acc = 0.0

    for epoch in range(num_epochs):
        print('Epoch %4d / %4d'%(epoch, num_epochs-1))
        print('-'*20)

        # Run a training epoch and then a validation one
        for phase in ['train', 'val']:
            print(phase)
            if phase == 'train':
                model.train()
            else:
                model.eval()

            running_loss = 0.0
            running_corrects = 0

            for idx, (inputs, labels) in enumerate(dataloaders[phase]):
                if (idx % 10 == 0):
                    print("Batch %4d/%4d (%4.2f %%)"%(idx, 
                            len(dataloaders[phase]), 
                            100*idx/len(dataloaders[phase])))
                inputs = inputs.to(device)
                labels = labels.to(device)

                # zero the parameter gradients
                optimizer.zero_grad()

                # forward
                outputs = model(inputs)
                loss = criterion(outputs, labels)

                _, preds = torch.max(outputs, 1)

                # backward + optimize only if in training phase
                if phase == 'train':
                    loss.backward()
                    optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(preds == labels.data)

            epoch_loss = running_loss / len(dataloaders[phase].dataset)
            epoch_acc = (running_corrects.double() / 
                    len(dataloaders[phase].dataset))
            print('%12s Loss: %8.4f Acc: %8.4f'%(phase, epoch_loss,
                    epoch_acc.item()))

            # deep copy the model if it's more accurate
            if phase == 'val' and epoch_acc > best_acc:
                best_acc = epoch_acc
                best_model_wts = copy.deepcopy(model.state_dict())
            if phase == 'val':
                val_acc_history.append(epoch_acc)
                
        print()

    time_elapsed = time.time() - since
    print('Training complete in %5d m %3d s'%(time_elapsed // 60, 
            time_elapsed % 60))
    print('Best val Acc: %8.4f'%best_acc)

def set_parameter_requires_grad(model, feature_extracting):
    if feature_extracting:
        for param in model.parameters():
            param.requires_grad == False
        
# Pretrained resnet18 will be the starting point
model = models.resnet18(pretrained=True)

# Prevent the convolutional layers from learning
for name, param in model.named_parameters():
    param.requires_grad = False

# Replace the last linear leayer with a sequece of FC layers
# In order to classify five different diagnoses
in_feature = model.fc.in_features
model.fc = nn.Sequential(
        nn.Linear(in_feature, 500, bias=True),
        nn.BatchNorm1d(500),
        nn.ReLU(),
        nn.Linear(500, 50, bias=True),
        nn.BatchNorm1d(50),
        nn.ReLU(),
        nn.Linear(50, 5, bias=True)
        )
# New layers automatically require gradients, so this is optional
# but more explicit:
#model.fc.weight.requires_grad_(True)
#model.fc.bias.requires_grad_(True)

#for name, param in model.named_parameters():
#    print(name, param.requires_grad)

model.to(device)

# Adam optimizer with default params except learning rate
optimizer = torch.optim.Adam(model.parameters(), lr=0.05)
criterion = nn.CrossEntropyLoss()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.RandomHorizontalFlip(),
    transforms.RandomVerticalFlip(),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# Make datasets and data loaders
train_dataset = RetinopathyDatasetTrain(csv_file=drive_str+'train.csv',
        transform = transform)
train_dataset, val_dataset = torch.utils.data.random_split(
        train_dataset, [int(len(train_dataset)*0.8), 
        int(len(train_dataset)*0.2)+1])

train_data_loader = torch.utils.data.DataLoader(train_dataset, batch_size=32,
        shuffle=True)

val_data_loader = torch.utils.data.DataLoader(val_dataset, batch_size=32,
        shuffle=True)

# Make sure to overfit a single batch to make sure it works before you 
# do the full training

#train_single_batch(model, optimizer, criterion, train_data_loader, 50)

dataloaders = {'train' : train_data_loader, 'val' : val_data_loader}

# This is where the model is trained
num_epochs = 30
train_model(model, dataloaders, criterion, optimizer, num_epochs)


# Loader for test set
#test_dataset = RetinopathyDatasetTest(csv_file=drive_str+'test.csv',
#        transform=transform)
#test_data_loader = torch.utils.data.DataLoader(test_dataset, batch_size=32,
#        shuffle=True, num_workers=1)








