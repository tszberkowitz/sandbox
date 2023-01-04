# matplotlib_labels.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_labels.asp

import numpy as np
import matplotlib.pyplot as plt

# Define data points
x = np.array([80, 85, 90, 95, 100, 105, 110, 115, 120, 125])
y = np.array([240, 250, 260, 270, 280, 290, 300, 310, 320, 330])

# Create plot
plt.plot(x, y)

# Use `xlabel()` and `ylabel()` functions to add labels to x and y axes, respectively
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")

# Display plot
plt.show()


# Use the `title()` function to add a title to the plot
plt.plot(x, y)
plt.title("Sports Watch Data")
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")
plt.show()


# Set font properties of plot title and axis labels from dictionaries of
# properties passed to the `fontdict=` argument of the `title()`, `xlabel()`,
# and `ylabel()` functions
font1 = { 'family': 'serif', 'color': 'blue', 'size': 20 }
font2 = { 'family': 'serif', 'color': 'darkred', 'size': 15 }
plt.plot(x, y)

plt.title("Sports Watch Data", fontdict=font1)
plt.xlabel("Average Pulse", fontdict=font2)
plt.ylabel("Calories Burned", fontdict=font2)

plt.show()


# Use the `loc=` argument of the `title()` function to place the plot title
## NB: Valid options are 'center' (default), 'left', and 'right'.
plt.plot(x, y)

plt.title("Sports Watch Data", loc="left")
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")

plt.show()






