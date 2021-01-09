import sys

sys.path.append('/usr/local/lib/python2.7/site-packages')

import cv2

img = cv2.imread('/Users/raghav/Desktop/1.png')

thresh = 150

maxValue = 255

th, dst = cv2.threshold(img, thresh, maxValue, cv2.THRESH_TOZERO)

cv2.imshow("original image", img)

cv2.imshow("new image", dst)

cv2.waitKey(0)

cv2.destroyAllWindows()