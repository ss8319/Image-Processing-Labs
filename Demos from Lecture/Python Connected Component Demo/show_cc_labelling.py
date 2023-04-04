# To run this demo, use python show_cc_labelling.py
# The reason for this stand-alone demo (not in a notebook)
# is because on some installations on Mtplotlib, the external
# viewer does not pop up: the external viewer allows one
# to zoom into a portion of the image and also to hover
# the mouse over regions to see the value that is in the 
# image array (as opposed to just its intensity/colour).
# This facility is usually not available directly in the
# Jupyter notebook, or lab or VS Code.
from skimage.measure import label
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

pilX = Image.open('IMGS/rice.png')
X = np.asarray(pilX, dtype=int)
np.shape(X)
plt.imshow(X, cmap='gray')

B = X > 140 # somewhat arbitrary, but check hostogram
plt.imshow(B, cmap='gray')
L = label(B)
plt.imshow(L)
plt.show()