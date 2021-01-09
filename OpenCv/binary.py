# binary images

# 1 = white
# 0 = black

import cv2

img = cv2.imread("/Users/raghav/Desktop/1.png", 0)

cv2.imshow("output image", img)

cv2.waitKey(0)

ret, bw = cv2.threshold(img, 138, 255, cv2.THRESH_BINARY)

cv2.imshow("binary", bw)

cv2.waitKey(0)

cv2.destroyAllWindows()