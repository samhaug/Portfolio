# Santander transactions

Two neural networks designed to predict likelihood of a future transaction
given a history of previous transactions

Each row of the dataset contains 200 features. Many of these features 
are uncorrelated with eachother. Embed.py performs a dimensionality reduction
on the dataset in order to find hidden relationships between the features, and
ends up scoring better than baseline.py by around 4 percent.
