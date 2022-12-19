# pandas_csv
# Modified on 2022-12-18 from https://www.w3schools.com/python/pandas/pandas_csv.asp

import pandas as pd

# Read a CSV file into a DataFrame object
df = pd.read_csv('./data/data.csv')

# Print DataFrame (truncated to first and last 5 rows if too many observations)
print(df)

# Print DataFrame (no truncation -- this prints the entire data set)
print(df.to_string())

# Print maximum rows displayed in full
### NB: The number of rows in an object greater than which pandas will print a truncated version of the object is determined by the pandas option `pd.options.display.max_rows`.
print(pd.options.display.max_rows)

# # Change maximum number of rows to print
# pd.options.display.max_rows = 9999
# print(df)
