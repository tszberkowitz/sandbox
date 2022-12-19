# panda_series
# Modified on 2022-12-17 from https://www.w3schools.com/python/pandas/pandas_series.asp
# Import pandas module
import pandas as pd

# Create a list
a = [1, 7, 2]

# Create a Series from a list
myvar = pd.Series(a)

# Print the Series
print(myvar)

# Print the first value in the Series
print(myvar[0])

#------------------------------------------------------------------------

# Create labels
myvar = pd.Series(a, index = ["x", "y", "z"])

print(myvar)

# Return the value labeled "y"
print(myvar["y"])


#------------------------------------------------------------------------

# Key/value objects as Series

calories = {"day1": 420, "day2": 380, "day3": 390}

myvar = pd.Series(calories)

print(myvar)

# Use the `index=` argument to select only some of the dictionary elements
myvar = pd.Series(calories, index = ["day1", "day2"])
print(myvar)


#------------------------------------------------------------------------

# DataFrames teaser

data = {
    "calories": [420, 380, 390],
    "duration": [50, 40, 45]
}

myvar = pd.DataFrame(data)

print(myvar)


