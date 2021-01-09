import cv2 
import numpy as np

img = cv2.imread("/Users/raghav/Desktop/1.png", 0)

cv2.imshow("original", img)
h,w = img.shape[0:2]

binary = np.zeros([h, w, 1], 'uint8')

for i in range(0,h):
	for j in range(0,w):
		if(img[i][j]<167):
			binary[i][j]=0
		else:
			binary[i][j] = 255	

cv2.imshow("new", binary)

cv2.waitKey(0)
cv2.destroyAllWindows()