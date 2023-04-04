#!/usr/bin/env python
# coding: utf-8


import numpy as np
import skimage as ski
import matplotlib.pyplot as plt
from skimage.transform import radon
import matplotlib


# ## Demonstration of the Radon Transform
# 
# The Radon transform is used as part of the so-called Straight-Line Hough transform. The only extra bits that the Straight-Line Hough transform has is a mapping of grey-scale image to a binary edge map (see Practical 4), before applying the Radon transform to the edge map to detect the presence of geometrically linear structures in an image.  The elegant bit is the Radon Transform itself.
# 
# This material is *not* examinable: it is provided as an example that is particularly vivid (and so, helps overall appreciation of one of the key applications of image transforms) of how large values in transform space can be indicative of particular visual structures in the input image (or image space). 
# 
# In this case, for a binary image, "1" pixels that are in linear alignment in image space generate a strong response in transform space. It is also provides an example of a form of linear image transform where an _exact_ inverse is not possible.


# One line in an image.. note the 'line' is discontinuous:
# really, we have pixels "in a line", with gaps in between.


f1 = np.zeros((64,64),dtype=float)


for i in range(10,42,3):
    f1[i,i] = 1

plt.imshow(f1, cmap='gray')
plt.show()


R1 = radon(f1)
plt.imshow(R1, cmap='gray')
plt.xlabel('Angle in degrees')
plt.ylabel('Offset in image space')
plt.show()

# The coordinate system for the transform space is something like this (though I can't guarantee this is not confusing, or correct given the Python implementation, but you get the general idea of what "offset" refers to).
# 
# ![Hough Transform Coordinate Space. ](./R_theta_line.png)
# _Hough Transform Coordinate Space. For those invisible lines through iimage space. To get an understanding of this coordinate system, play around yourself with the values of $r$ and $\theta$._

# ## Same example, just different rendering


# ## Two lines...two peaks!


f2 = np.zeros((64,64), dtype=float)
for i in range(10,42,3):
    f2[i,i] = 1
    f2[i,64-i] = 1

plt.imshow(f2, cmap='gray')
plt.show()


R2 = radon(f2)
plt.imshow(R2, cmap='gray')
plt.xlabel('Angle in degrees')
plt.ylabel('Offset in image space')
plt.show()




