import cv2
import numpy as np

img = cv2.imread("/Users/raghav/Desktop/OpenCv/11.jpg")

cv2.imshow("output image", img)

cv2.waitKey(0)

B,G,R = cv2.split(img)

zeros = np.zeros(img.shape[:2], dtype="uint8")

cv2.imshow("red", cv2.merge([zeros, zeros, R]))

cv2.waitKey(0)

cv2.imshow("green", cv2.merge([zeros, G, zeros]))

cv2.waitKey(0)

cv2.imshow("blue", cv2.merge([B, zeros, zeros]))

cv2.waitKey(0)

cv2.destroyAllWindows()