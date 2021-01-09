import cv2 as cv
import numpy as np
img = cv.imread("/Users/raghav/Desktop/1.png", 0)
kernel = np.ones((5,5),np.uint8)
erosion = cv.erode(img,kernel,iterations = 1)
dilation = cv.dilate(img,kernel,iterations = 1)

cv.imshow("new", kernel)
cv.imshow("new", erosion)
cv.imshow("new", dilation)


cv.waitKey(0)
cv.destroyAllWindows()