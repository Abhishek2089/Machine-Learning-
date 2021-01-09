import cv2

img = cv2.imread("/Users/raghav/Desktop/Open Cv/11.jpg")

cv2.imshow("Output image", img)

cv2.waitKey(0)

cv2.destroyAllwindows()