import pandas as pd
import torch
from torch.utils.data import TensorDataset
from torch.utils.data import random_split


def get_data():
    train_data = pd.read_csv("train.csv")
    y = train_data[['target']]
    X = train_data.drop(['ID_code', 'target'], axis=1)
    y_ten = torch.tensor(y.values, dtype=torch.float32)
    X_ten = torch.tensor(X.values, dtype=torch.float32)
    ds = TensorDataset(X_ten, y_ten)

    train_ds, val_ds = random_split(ds, [int(0.8*len(ds)), 
            len(ds)-int(0.8*len(ds))])

    test_data = pd.read_csv("test.csv")
    test_ids = test_data[['ID_code']]
    X = test_data.drop(['ID_code'], axis=1)
    X_ten = torch.tensor(X.values, dtype=torch.float32)
    y_ten = torch.tensor(y.values, dtype=torch.float32)
    test_ds = TensorDataset(X_ten, y_ten)

    return train_ds, val_ds, test_ds, test_ids
