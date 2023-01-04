# matplotlib_lines.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_line.asp

import matplotlib.pyplot as plt
import numpy as np

ypoints = np.array([3, 8, 1, 10])

# Change line type by using the `linestyle=` (or equivalently `ls=`) argument
plt.plot(ypoints, linestyle='dotted')   # alternatively `linestyle=':'`, `ls='dotted'`, or `ls=':'`
plt.show()

# Use dashed line
plt.plot(ypoints, linestyle='dashed')   # alternatively `linestyle='--'`, `ls='dashed'`, or `ls='--'`
plt.show()

# Style	            Or
# 'solid' (default)	'-'	
# 'dotted'	        ':'	
# 'dashed'	        '--'	
# 'dashdot'	        '-.'	
# 'None'	        '' or ' '


# Specify line color using `color=` (or alternatively `c=`) argument
## NB: Can use color names, shorthand, or hex codes.
plt.plot(ypoints, color='r')   # alternatively, `c='r'`
# plt.plot(ypoints, color='#4CAF50')
plt.show()



# Specify line width as a quoted floating point value in units of points using `linewidth=` (or alternatively `lw=`) argument
plt.plot(ypoints, linewidth='20.5')
plt.show()



# Plot multiple lines by calling `plt.plot()` on multiple sets of points
y1 = np.array([3, 8, 1, 10])
y2 = np.array([6, 2, 7, 11])

plt.plot(y1)
plt.plot(y2)
plt.show()

# Alternatively, pass multiple pairs of xy coordinates to plot multiple lines
x1 = np.array([0, 1, 2, 3])
y1 = np.array([3, 8, 1, 10])
x2 = np.array([0, 1, 2, 3])
y2 = np.array([6, 2, 7, 11])

plt.plot(x1, y1, x2, y2)
plt.show()



