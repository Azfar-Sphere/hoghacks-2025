from deepface import DeepFace
import cv2
import json
import numpy as np

# Load the video 
capture = cv2.VideoCapture("IMG_6171.MOV")

frame_skip = 5
frame_count = 0

y_history = []
max_history = 5

threshold = 120

# Read the video frame by frame
while True:
    # Returns ret = true if the frame exists and numpy array of image
    ret, frame = capture.read()

    if not ret:
        break

    frame = cv2.rotate(frame, cv2.ROTATE_180)

    frame_count += 1

    if frame_count % frame_skip != 0:
        continue

    faces = DeepFace.extract_faces(frame, enforce_detection=False)

    if not faces:
        print("No Faces detected")
        continue

    for i, face in enumerate(faces):

        x = face['facial_area']['x']
        y = face['facial_area']['y']
        w = face['facial_area']['w']
        h = face['facial_area']['h']

        face_center_y = y+h // 2
        y_history.append(face_center_y)
        if len(y_history) > max_history:
            y_history.pop(0)

        if len(y_history) == max_history:
            dy = np.diff(y_history)
            if (np.max(dy) > threshold and np.min(dy) < -120):
                cv2.putText(frame, "NOD Detected", (x, y + 250), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      



        cropped_face = frame[y:y+h, x:x+w]
        if cropped_face.shape[0] < 100 or cropped_face.shape[1] < 100:
            cropped_face = cv2.resize(cropped_face, (100, 100))


        analysis = DeepFace.analyze(cropped_face, actions=['age', 'gender','emotion'], enforce_detection=False)

        # print(f"\n\nAnalysis: {analysis} \n\n")

        # print(f"Age: {analysis[0]['age']}, Gender: {analysis[0]['gender']}, Emotion: {analysis[0]['emotion']}")


        cv2.rectangle(frame, (x,y), (x+w, y+h), (0, 0, 255), 2)
        cv2.putText(frame, f"Age: {analysis[0]['age']}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      



        cv2.putText(frame, f"Emotion: {analysis[0]['dominant_emotion']}", (x+150, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)


        
    cv2.imshow("Frame", frame)

    key = cv2.waitKey(10) & 0xFF  

    if key == ord('q'):
        break

capture.release()
cv2.destroyAllWindows()
