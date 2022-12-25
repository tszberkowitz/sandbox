# pandas_cleaning_duplicates.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_cleaning_duplicates.asp

import pandas as pd

df = pd.read_csv('data/data_dirty.csv')

## NB: Rows 11 and 12 are identical

# Return a boolean for every row to identify which rows are duplicates
print(df.duplicated())

# Remove duplicate rows in-place
df.drop_duplicates()
print(df.to_string())
