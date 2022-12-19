# pandas_dataframes
# Modified on 2022-12-18 from https://www.w3schools.com/python/pandas/pandas_dataframes.asp

import pandas as pd

# Create a simple DataFrame

data = {
    "calories": [420, 380, 390],
    "duration": [50, 40, 45]
}

df = pd.DataFrame(data)

print(df)

# Print row 0 (the first row)
### NB: This returns a Series object.
print(df.loc[0])

# Print row 0
### NB: This returns a DataFrame object
print(df.loc[[0]])

# Print rows 0 and 1 (the first 2 rows)
print(df.loc[[0, 1]])


#------------------------------------------------------------------------------

# Specify names for named indexes
df = pd.DataFrame(data, index = ["day1", "day2", "day3"])

print(df)

# Return data for index value "day2"
### NB: This returns a Series object.
print(df.loc["day2"])

# Return data for index value "day2"
### NB: This returns a DataFrame object.
print(df.loc[["day2"]])

# Return data for index values "day2" and "day3"
print(df.loc[["day2", "day3"]])



