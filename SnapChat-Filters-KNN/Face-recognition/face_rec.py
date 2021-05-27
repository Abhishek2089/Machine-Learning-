

import cv2
import numpy as np
import os

cap = cv2.VideoCapture(0)
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

skip = 0
face_data = []
label = []
dataset_path = './data/'

class_id = 0
names = {}


file_name = input('Enter the name of the person: ')

while True:
	ret, frame = cap.read()
	gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

	if ret == False:
		continue

	faces = face_cascade.detectMultiScale(gray_frame, 1.3, 5) 
	faces = sorted(faces, key=lambda f:f[2]*f[3])


	# cv2.imshow("Gray frame", gray_frame)

	for (x,y,w,h) in faces[-1:]:
		cv2.rectangle(frame, (x,y), (x+w,y+h), (255,0,0),2)

		offset = 10
		face_scetion = frame[y-offset:y+h+offset, x-offset:x+w+offset]
		face_scetion = cv2.resize(face_scetion, (100,100))

		skip += 1
		if skip % 10 == 0:
			face_data.append(face_scetion)
			print(len(face_data)) 
	
	cv2.imshow("Video frame", frame)
	cv2.imshow("Extracted face", face_scetion)

	key_pressed = cv2.waitKey(1) & 0xFF
	if key_pressed == ord('q'):
		break

# convert face data into numpy array

face_data = np.asarray(face_data)
face_data = face_data.reshape((face_data.shape[0], -1))
print(face_data.shape)

np.save(dataset_path+file_name+'.npy', face_data)
print("Data successfully save at"+dataset_path+file_name+'.npy')
cap.release()
cv2.destroyAllWindows()	