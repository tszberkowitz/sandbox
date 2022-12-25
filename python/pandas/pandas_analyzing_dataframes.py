# pandas_analyzing_dataframes.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_analyzing.asp

import pandas as pd

df = pd.read_csv('data/data.csv')

## Viewing the data

# View first 10 rows
print(df.head(10))

# View first 5 rows (default)
print(df.head())

# View last 10 rows
print(df.tail(10))

# View last 5 rows (default)
print(df.tail())


## Info about the data

# Print info about data set
print(df.info())
## Data set has 169 rows and 4 columns
## Note the `Calories` field contains 5 null values


