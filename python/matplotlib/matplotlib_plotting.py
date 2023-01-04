# matplotlib_plotting.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_plotting.asp

import matplotlib.pyplot as plt
import numpy as np

# GOAL: Plot a line from (1,8) to (3,10)

# Define point arrays
xpoints = np.array([1, 3])
ypoints = np.array([8, 10])

# Create plot
plt.plot(xpoints, ypoints)

# Display plot
plt.show()


# Plot only the coordinates (no line)
plt.plot(xpoints, ypoints, 'o') # <- 'o' == 'rings', i.e., points/markers
plt.show()


# Draw a line in a diagram from position (1, 3) to (2, 8) then to (6, 1) and finally to position (8, 10):
xpoints = np.array([1, 2, 6, 8])
ypoints = np.array([3, 8, 1, 10])

plt.plot(xpoints, ypoints)
plt.show()

## NB: Plotting without specify x-axis results in use of indices as x-coordinates
plt.plot(ypoints)
plt.show()




