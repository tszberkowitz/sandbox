# pandas_cleaning_emptycells.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_cleaning_empty_cells.asp

import pandas as pd

df = pd.read_csv('data/data_dirty.csv')

# Print info about original data set
print(df.info())

# # Print original data set
# print(df.to_string())


## Removing missing values

# Remove rows with any missing values
## NB: By default, `dropna()` returns a new DataFrame without missing values; it does *not* modify the original DataFrame.
new_df = df.dropna()

# Print cleaned data
print(new_df.to_string())

# # To remove missing values from the original data set, use `inplace=True`
# ## NB: `inplace=True` does *not* return a new DataFrame -- it just modifies the original DataFrame by removing all missing values
# df.dropna(inplace=True)
# print(df.to_string())



## Replacing missing values

# # Replace missing values in all columns with a specific value (modifies original data set)
# ## NB: This example replaces missing values with the numeric value 130.
# ## NB: By default, `fillna()` returns a new DataFrame with no missing values -- it does *not* modify the original data
# df.fillna(130, inplace=True)

# Replace missing values in specific columns with a specific value (returns an updated copy of the data set)

# Replace missing values in the `Calories` column only with the numeric value 130
# new_df = df["Calories"].fillna(130)  ### <-- this does not do what you want; it only returns the modified column(s)
new_df = df.copy()
new_df["Calories"].fillna(130, inplace=True)
print(new_df.to_string())


# Replace missing values in a numeric column with the mean, median, or mode of the column
new_df = df.copy()
x_mean = new_df["Calories"].mean()
x_median = new_df["Calories"].median()
x_mode = new_df["Calories"].mode()[0]

# # Replace missing with mean
# new_df["Calories"].fillna(x_mean, inplace=True)

# # Replace missing with mean
# new_df["Calories"].fillna(x_median, inplace=True)

# # Replace missing with mean
# new_df["Calories"].fillna(x_mode, inplace=True)


