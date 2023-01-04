# matplotlib_pyplot.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_pyplot.asp

import matplotlib.pyplot as plt
import numpy as np

# GOAL: Draw a line from (0,0) to (6,250) on a graph

# Define coordinate points
xpoints = np.array([0, 6])
ypoints = np.array([0, 250])

# Create plot
plt.plot(xpoints, ypoints)

# Display plot
plt.show()

