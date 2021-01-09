import cv2

img = cv2.imread("/Users/raghav/Desktop/OpenCv/11.jpg")

cv2.imshow("output image", img)

cv2.waitKey(0)


#another method to convert img to b/w

gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

cv2.imshow("b/w_image", gray_img)

cv2.waitKey(0)

cv2.destroyAllWindows()