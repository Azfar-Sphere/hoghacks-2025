from deepface import DeepFace
import cv2
import json
import numpy as np

# Load the video 
capture = cv2.VideoCapture("IMG_6168.MOV")

frame_skip = 5
frame_count = 0

# Read the video frame by frame
while True:
    # Returns ret = true if the frame exists and numpy array of image
    ret, frame = capture.read()

    if not ret:
        break

    frame = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)

    frame_count += 1

    if frame_count % frame_skip != 0:
        continue

    faces = DeepFace.extract_faces(frame, enforce_detection=False)

    if not faces:
        print("No Faces detected")
        continue

    for i, face in enumerate(faces):
        analysis = DeepFace.analyze(face['face'], actions=['age', 'gender','emotion'], enforce_detection=False)

        print(f"Age: {analysis[0]['age']}, Gender: {analysis[0]['gender']}, Emotion: {analysis[0]['emotion']}")

        x = face['facial_area']['x']
        y = face['facial_area']['y']
        w = face['facial_area']['w']
        h = face['facial_area']['h']


        cv2.rectangle(frame, (x,y), (x+w, y+h), (0, 0, 255), 2)
        cv2.putText(frame, f"Age: {analysis[0]['age']}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      

        emotion_dict = analysis[0]['emotion']
        dominant_emotion = max(emotion_dict, key=emotion_dict.get)

        cv2.putText(frame, f"Emotion: {dominant_emotion}", (x+150, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)


        
    cv2.imshow("Frame", frame)

    key = cv2.waitKey(1) & 0xFF  

    if key == ord('q'):
        break

capture.release()
cv2.destroyAllWindows()
