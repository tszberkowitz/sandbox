# matplotlib_markers.py
# Modified on 2022-12-25 from https://www.w3schools.com/python/matplotlib_markers.asp

import matplotlib.pyplot as plt
import numpy as np

ypoints = np.array([3, 8, 1, 10])

# Mark points with circles
plt.plot(ypoints, marker='o')
plt.show()


# Mark points with stars
plt.plot(ypoints, marker='*')
plt.show()

# Marker	Description
# 'o'	    Circle	
# '*'	    Star	
# '.'	    Point	
# ','	    Pixel	
# 'x'	    X	
# 'X'	    X (filled)	
# '+'	    Plus	
# 'P'	    Plus (filled)	
# 's'	    Square	
# 'D'	    Diamond	
# 'd'	    Diamond (thin)	
# 'p'	    Pentagon	
# 'H'	    Hexagon	
# 'h'	    Hexagon	
# 'v'	    Triangle Down	
# '^'	    Triangle Up	
# '<'	    Triangle Left	
# '>'	    Triangle Right	
# '1'	    Tri Down	
# '2'	    Tri Up	
# '3'	    Tri Left	
# '4'	    Tri Right	
# '|'	    Vline	
# '_'	    Hline


# Specify markers using string notation shorthand via `fmt=` argument
## NB: `fmt=` string is specified as `marker|line|color`.
## NB: If you omit the `line` component then no line will be plotted
plt.plot(ypoints, 'o:r')
plt.show()

# Line Syntax	Description
# '-'	        Solid line	
# ':'	        Dotted line	
# '--'	        Dashed line	
# '-.'	        Dashed/dotted line

# Color Syntax	Description
# 'r'	        Red	
# 'g'	        Green	
# 'b'	        Blue	
# 'c'	        Cyan	
# 'm'	        Magenta	
# 'y'	        Yellow	
# 'k'	        Black	
# 'w'	        White

# Specify marker size using `markersize=` (or equivalently `ms=`) argument
plt.plot(ypoints, marker='o', markersize=20)
plt.show()

# Specify marker edge color (aka, its outline color) using `markeredgecolor=` (or equivalently `mec=`) argument
plt.plot(ypoints, marker='o', markersize=20, markeredgecolor='r')
plt.show()

# Specify marker face color (aka, its fill color) using `markerfacecolor=` (or equivalently `mfc=`) argument
plt.plot(ypoints, marker='o', markersize=20, markerfacecolor='r')
plt.show()

# Specify both marker edge and face colors to color entire marker
plt.plot(ypoints, marker='o', markeredgecolor='r', markerfacecolor='r')
plt.show()

# Specify colors using color hex codes
plt.plot(ypoints, marker='o', markeredgecolor='#4CAF50', markerfacecolor='#4CAF50')
plt.show()










