# pandas_correlation.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_correlations.asp

import pandas as pd

df = pd.read_csv('data/data.csv')

print(df.corr())

## NB: `corr()` ignores columns that are not numeric
