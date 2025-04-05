from deepface import DeepFace
import cv2
import json
import numpy as np
import mediapipe as mp



#Setup mediapipe
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(static_image_mode=True, max_num_faces=5)
mp_drawing = mp.solutions.drawing_utils

# Load the video 
capture = cv2.VideoCapture("IMG_6171.MOV")

frame_skip = 2
frame_count = 0

y_chin_history = []
y_nose_history = []
max_history = 7

threshold = 0.07

# Read the video frame by frame
while True:
    # Returns ret = true if the frame exists and numpy array of image
    ret, frame = capture.read()

    if not ret:
        break

    frame = cv2.resize(frame, (640, 480))
    frame = cv2.rotate(frame, cv2.ROTATE_180)

    frame_count += 1

    if frame_count % frame_skip != 0:
        continue

    faces = DeepFace.extract_faces(frame, enforce_detection=False)

    if not faces:
        print("No Faces detected")
        continue

    #Facial Landmarks
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = face_mesh.process(frame)

    chin = result.multi_face_landmarks[0].landmark[152]
    nose = result.multi_face_landmarks[0].landmark[1]

    image_height, image_width, _ = frame.shape
    chin_x = int(chin.x * image_width)
    chin_y = int(chin.y * image_height)

    nose_x = int(nose.x * image_width)
    nose_y = int(nose.y * image_height)

    cv2.circle(frame, (chin_x, chin_y), 5, (0,0,255), 3)
    cv2.circle(frame, (nose_x, nose_y), 5, (0,0,255), 3)

    face_height = 0

    # Detect Age
    for i, face in enumerate(faces):

        x = face['facial_area']['x']
        y = face['facial_area']['y']
        w = face['facial_area']['w']
        h = face['facial_area']['h']

        face_height = h

        cropped_face = frame[y:y+h, x:x+w]
        if cropped_face.shape[0] < 100 or cropped_face.shape[1] < 100:
            cropped_face = cv2.resize(cropped_face, (100, 100))

        analysis = DeepFace.analyze(cropped_face, actions=['age'], enforce_detection=False)

        # print(f"\n\nAnalysis: {analysis} \n\n")
        # print(f"Age: {analysis[0]['age']}, Gender: {analysis[0]['gender']}, Emotion: {analysis[0]['emotion']}")

        cv2.rectangle(frame, (x,y), (x+w, y+h), (0, 0, 255), 2)
        cv2.putText(frame, f"Age: {analysis[0]['age']}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      


    # Detect Nod:
    y_chin_history.append(chin_y)
    y_nose_history.append(nose_y)

    if len(y_chin_history) > max_history:
        y_chin_history.pop(0)

    if len(y_nose_history) > max_history:
        y_nose_history.pop(0)


    if len(y_chin_history) == max_history and len(y_nose_history) == max_history:
        dy_chin = np.diff(y_chin_history) / h
        dy_nose = np.diff(y_nose_history) / h 

        chin_movement = np.max(dy_chin) - np.min(dy_chin)
        nose_movement = np.max(dy_nose) - np.min(dy_nose)

        if (chin_movement > threshold and nose_movement > threshold):
            cv2.putText(frame, f"Nod Detected", (x, y + 150), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      


    cv2.imshow("Frame", frame)

    key = cv2.waitKey(100)

    if key == ord('q'):
        break

capture.release()
cv2.destroyAllWindows()
