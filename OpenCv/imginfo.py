import cv2

img = cv2.imread("/Users/raghav/Desktop/Open Cv/11.jpg")

cv2.imshow("output image", img)

print(img.shape)

cv2.waitKey(0)

cv2.destroyAllWindows()