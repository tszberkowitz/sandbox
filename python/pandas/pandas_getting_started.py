# pandas_getting_started
# Copied on 2022-12-17 from https://www.w3schools.com/python/pandas/pandas_getting_started.asp
#import pandas
import pandas as pd

mydataset = {
    'cars': ["BMW", "Ford", "Volvo"],
    'passings': [3, 7, 2]
}

# myvar = pandas.DataFrame(mydataset)
myvar = pd.DataFrame(mydataset)

print(myvar)