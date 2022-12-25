# pandas_cleaning_wrongdata.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_cleaning_wrong_data.asp

import pandas as pd

df = pd.read_csv('data/data_dirty.csv')

print(df.to_string())

# # Replace suspected typo (`450` -> `45`)
# df.loc[7, "Duration"] = 45

# # Replace all values in a column that are outside of expected values
# for x in df.index:
#     if df.loc[x, "Duration"] > 120:
#         df.loc[x, "Duration"] = 120

# # Delete rows with a `Duration` value greater than 120
# for x in df.index:
#     if df.loc[x, "Duration"] > 120:
#         df.drop(x, inplace=True)

