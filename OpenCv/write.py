import cv2

img = cv2.imread("/Users/raghav/Desktop/OpenCv/11.jpg")

cv2.imshow("output image", img)

cv2.imwrite("img.png", img)

cv2.waitKey(0)

cv2.destroyAllWindows()