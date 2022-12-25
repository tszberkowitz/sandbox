# pandas_plotting.py
# Modified on 2022-12-24 from https://www.w3schools.com/python/pandas/pandas_plotting.asp

import pandas as pd
import matplotlib.pyplot as plt  # use the pyplot submodule of the matplotlib module for plotting

df = pd.read_csv('data/data.csv')

# Create a line plot (default)
df.plot()

# Display the plot
plt.show()


# Create a scatter plot with `Duration` on the x-axis and `Calories` on the y-axis
df.plot(kind='scatter', x='Duration', y='Calories')
plt.show()


# Create a scatter plot with `Duration` on the x-axis and `Maxpulse` on the y-axis
df.plot(kind='scatter', x='Duration', y='Maxpulse')
plt.show()


# Create a histogram of `Duration`
df['Duration'].plot(kind='hist')
plt.show()

