# pandas_cleaning_wrongformat.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_cleaning_wrong_format.asp

import pandas as pd

df = pd.read_csv('data/data_dirty.csv')

print(df.to_string())
## NB: Two values in the `Date` column are in the wrong format (row 22: missing, row 26: not quoted or delimited)

# Print info about original data
print(df.info())

# Convert the `Date` column from strings to dates
df["Date"] = pd.to_datetime(df["Date"])

# Confirm data type (`dtype`) of `Date` column has changed
print(df.info())

# Print modified data set
print(df.to_string())

## NB: `NaT` == "Not A Time" (cf. `NaN` == "Not A Number") so can be treated as a missing value by `dropna()`

# Remove rows with missing values in specific column(s)
df.dropna(subset=["Date"], inplace=True)

# Print cleaned data set
print(df.to_string())

