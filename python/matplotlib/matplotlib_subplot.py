# matplotlib_subplot.py
# Modified on 2023-01-08 from https://www.w3schools.com/python/matplotlib_subplot.asp

import numpy as np
import matplotlib.pyplot as plt

# You can display multiple plots via the `subplot()` function

# plot 1
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])

plt.subplot(1, 2, 1)
plt.plot(x, y)

# plot 2
x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])

plt.subplot(1, 2, 2)
plt.plot(x, y)

# Add an overall title with `suptitle()` function
plt.suptitle("Display multiple plots with `subplot()`")

# Display the multiple plots
plt.show()


### NB: The `subplot()` function takes 3 arguments that describe the figure layout. Figures are arranged in rows and columns.
###  - The first argument represents the row number (1-based) in which to plot the subplot
###  - The second argument represents the column number (1-based) in which to plot the subplot
###  - The third argument represents the (1-based) index of the current plot
### 
### Examples
### 
### plt.subplot(1, 2, 1)
### # The figure has 1 row (first argument) and 2 columns (second argument) for a total of 2 subplots and we are dealing with the first subplot (third argument)
### 
### plt.subplot(1, 2, 2)
### # The figure has 1 row (first argument) and 2 columns (second argument) and we are dealing with the second subplot


# Draw two plots on top of each other (instead of side-by-side)

# plot 1
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(2, 1, 1)
plt.plot(x, y)

# plot 2
x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(2, 1, 2)
plt.plot(x, y)

# Display the figure
plt.show()


# Plot 6 plots in a single figure (2 x 3 grid layout)
### NB: Plots are filled in left-to-right, then top-to-bottom, i.e., plots fill up the rows first
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(2, 3, 1)
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(2, 3, 2)
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(2, 3, 3)
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(2, 3, 4)
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(2, 3, 5)
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(2, 3, 6)
plt.plot(x, y)

plt.show()


# Add titles to each subplot with the `title()` function (1 x 2 grid layout)
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(1, 2, 1)
plt.title("SALES")
plt.plot(x, y)

x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(1, 2, 2)
plt.title("INCOME")
plt.plot(x, y)

plt.show()


# Add a title to the entire figure (a "super title") with the `suptitle()` function
x = np.array([0, 1, 2, 3])
y = np.array([3, 8, 1, 10])
plt.subplot(1, 2, 1)
plt.plot(x, y)
plt.title("SALES")

x = np.array([0, 1, 2, 3])
y = np.array([10, 20, 30, 40])
plt.subplot(1, 2, 2)
plt.plot(x, y)
plt.title("INCOME")

plt.suptitle("MY SHOP")

plt.show()


