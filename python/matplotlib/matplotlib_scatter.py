# matplotlib_scatter.py
# Modified on 2023-01-08 from https://www.w3schools.com/python/matplotlib_scatter.asp

import numpy as np
import matplotlib.pyplot as plt

# Create scatter plots with the `scatter()` function
### NB: The `scatter()` function requires 2 arrays of equal length for the x- and y-coordinates of the points.

x = np.array([5, 7, 8, 7, 2, 17, 2, 9, 4, 11, 12, 9, 6])
y = np.array([99, 86, 87, 88, 111, 86, 103, 87, 94, 78, 77, 85, 86])

plt.xlabel("Age (years)")
plt.ylabel("Speed (kph)")
plt.title("Car speed vs. age")

plt.scatter(x, y)
plt.show()



# Plot 2 days of observations on the same plot
#day one, the age and speed of 13 cars
x = np.array([5, 7, 8, 7, 2, 17, 2, 9, 4, 11, 12, 9, 6])
y = np.array([99, 86, 87, 88, 111, 86, 103, 87, 94, 78, 77, 85, 86])
plt.scatter(x, y)

#day two, the age and speed of 15 cars:
x = np.array([2,2,8,1,15,8,12,9,7,3,11,4,7,14,12])
y = np.array([100,105,84,105,90,99,90,95,94,100,79,112,91,80,85])
plt.scatter(x, y)

plt.xlabel("Age (years)")
plt.ylabel("Speed (kph)")
plt.title("Car speed vs. age")

plt.show()



# Specify custom colors of points with the `color=` argument or the `c=` argument in the `scatter()` function
#day one, the age and speed of 13 cars
x = np.array([5, 7, 8, 7, 2, 17, 2, 9, 4, 11, 12, 9, 6])
y = np.array([99, 86, 87, 88, 111, 86, 103, 87, 94, 78, 77, 85, 86])
plt.scatter(x, y, color = "hotpink")

#day two, the age and speed of 15 cars:
x = np.array([2,2,8,1,15,8,12,9,7,3,11,4,7,14,12])
y = np.array([100,105,84,105,90,99,90,95,94,100,79,112,91,80,85])
plt.scatter(x, y, color = "#88C999")

plt.xlabel("Age (years)")
plt.ylabel("Speed (kph)")
plt.title("Car speed vs. age")

plt.show()


# Specify custom colors for individual points by passing an array of colors to the `c=` argument in the `scatter()` function
### NB: This **cannot** be done with the `color=` argument; only the `c=` argument can be used here.
x = np.array([5, 7, 8, 7, 2, 17, 2, 9, 4, 11, 12, 9, 6])
y = np.array([99, 86, 87, 88, 111, 86, 103, 87, 94, 78, 77, 85, 86])
colors = np.array(["red","green","blue","yellow","pink","black","orange","purple","beige","brown","gray","cyan","magenta"])

plt.scatter(x, y, c = colors)
plt.xlabel("Age (years)")
plt.ylabel("Speed (kph)")
plt.title("Car speed vs. age")

plt.show()


