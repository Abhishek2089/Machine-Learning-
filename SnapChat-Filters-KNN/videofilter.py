import numpy as np
import cv2


cap = cv2.VideoCapture(0)
eyes_detector = cv2.CascadeClassifier("third-party/frontalEyes35x16.xml")
nose_detector = cv2.CascadeClassifier("third-party/Nose18x15.xml")



glass = cv2.imread("glasses.png",cv2.IMREAD_UNCHANGED)
glass = cv2.cvtColor(glass, cv2.COLOR_BGRA2RGBA)

moustache = cv2.imread("mustache.png", -1)



while True:
	ret, frame = cap.read()

	if ret == False:
		continue

	new_glass = eyes_detector.detectMultiScale(frame, 1.3, 5)
	eyes = sorted(new_glass, key=lambda f:f[2]*f[3])
	new_moustache = nose_detector.detectMultiScale(frame, 1.3, 5)
	nose = sorted(new_moustache, key=lambda f:f[2]*f[3])


	x,y,w,h = new_glass[0]

	glass = cv2.resize(glass, (w,h))

	for i in range(glass.shape[0]):
		for j in range(glass.shape[1]):
			if (glass[i,j,3]>3): 
				frame[y+i, x+j, :] = glass[i,j,:-1]


	x,y,w,h = new_moustache[0]

	mustache = cv2.resize(moustache, (w,h))

	for i in range(mustache.shape[0]):
		for j in range(mustache.shape[1]):
			if(mustache[i,j,3] > 3):
				frame[y+i, x+j, :] = mustache[i,j,:-1]

	cv2.imshow("Video Frame", frame)

	key_pressed = cv2.waitKey(1) & 0xFF
	if key_pressed == ord('q'):
		break


cap.release()
cv2.destroyAllWindows()