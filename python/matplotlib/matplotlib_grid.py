# matplotlib_grid.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_grid.asp

import numpy as np
import matplotlib.pyplot as plt

x = np.array([80, 85, 90, 95, 100, 105, 110, 115, 120, 125])
y = np.array([240, 250, 260, 270, 280, 290, 300, 310, 320, 330])

plt.title("Sports Watch Data")
plt.xlabel("Average Pulse")
plt.ylabel("Calorie Burnage")

plt.plot(x, y)

# Add gridlines (on both axes) to plot
plt.grid()

plt.show()


# Use `axis=` argument of the `grid()` function to specify gridlines
## NB: Valid values are 'x', 'y', and 'both' (default).
plt.plot(x, y)
plt.title("Sports Watch Data")
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")
plt.grid(axis='x')
plt.show()


plt.plot(x, y)
plt.title("Sports Watch Data")
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")
plt.grid(axis='y')
plt.show()



# Set line properties of grid lines via the `color=`, `linestyle=`, and `linewidth=` arguments
plt.title("Sports Watch Data")
plt.xlabel("Average Pulse")
plt.ylabel("Calories Burned")
plt.plot(x, y)
plt.grid(color = "green", linestyle = "--", linewidth = 0.5)
plt.show()


