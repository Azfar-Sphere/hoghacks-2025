from deepface import DeepFace
import cv2
import json
import numpy as np
import mediapipe as mp



#Setup mediapipe
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(static_image_mode=True, max_num_faces=1)
mp_drawing = mp.solutions.drawing_utils

# Load the video 
capture = cv2.VideoCapture("IMG_6171.MOV")

# Setup frame Skipping
frame_skip = 5
frame_count = 0

# Initializes Empty Lists for Chin, Nose, Forehead, Ears and Cheek Histories
y_chin_history = []
x_chin_history = []


y_nose_history = []
x_nose_history = []

y_forehead_history = []
x_forehead_history = []

y_left_ear_history = []
x_left_ear_history = []

y_right_ear_history = []
x_right_ear_history = []

y_left_cheek_history = []
x_left_cheek_history = []

y_right_cheek_history = []
x_right_cheek_history = []


# Sets the Maximum number of Frames to Look and compare movement between
max_history = 7

# Sets up Dict to store headshakes and nods in a video
movement_dict = {
    "headshake":0,
    "nod":0
}



# Read the video frame by frame
while True:
    # Returns ret = true if the frame exists and numpy array of image
    ret, frame = capture.read()

    if not ret:
        break

    #Resized image to 640x480
    frame = cv2.resize(frame, (640, 480))
    frame = cv2.rotate(frame, cv2.ROTATE_180)

    #Adds frame count
    frame_count += 1

    #Skips frames
    if frame_count % frame_skip != 0:
        continue

    #Extracts the faces from the video 
    faces = DeepFace.extract_faces(frame, enforce_detection=False)

    # if not faces:
    #     print("No Faces detected")
    #     continue

    #Facial Landmarks
    valid_points = {
        "chin": False,
        "nose": False,
        "forehead": False,
        "left_ear": False,
        "right_ear": False,
        "left_cheek": False,
        "right_cheek": False,
    }

    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = face_mesh.process(frame)
    image_height, image_width, _ = frame.shape

        # Gets Chin, Nose, Forehead, Ears and Cheek coordinates from the facial landmarks, if such coordinates exists, 
        # sets their value to true in valid_points dicts
        # Also draws the points on the facial frames

    try:
        chin = result.multi_face_landmarks[0].landmark[152]
        chin_x = int(chin.x * image_width)
        chin_y = int(chin.y * image_height)
        valid_points['chin'] = True
        cv2.circle(frame, (chin_x, chin_y), 5, (0,0,255), 3)
    except:
        pass

    try:
        nose = result.multi_face_landmarks[0].landmark[1]
        nose_x = int(nose.x * image_width)
        nose_y = int(nose.y * image_height)
        valid_points['nose'] = True
        cv2.circle(frame, (nose_x, nose_y), 5, (0,0,255), 3)
    except:
        pass

    try:
        forehead = result.multi_face_landmarks[0].landmark[10]
        forehead_x = int(forehead.x * image_width)
        forehead_y = int(forehead.y * image_width)
        valid_points['forehead'] = True
        cv2.circle(frame, (forehead_x, forehead_y), 5, (0,0,255), 3)
    except:
        pass

    try:
        left_ear = result.multi_face_landmarks[0].landmark[389]
        left_ear_x = int(left_ear.x * image_width)
        left_ear_y = int(left_ear.y * image_height)
        valid_points["left_ear"] = True
        cv2.circle(frame, (left_ear_x, left_ear_y), 5, (255, 255, 0), 3)
    except:
        pass

    try:
        right_ear = result.multi_face_landmarks[0].landmark[162]
        right_ear_x = int(right_ear.x * image_width)
        right_ear_y = int(right_ear.y * image_height)
        valid_points["right_ear"] = True
        cv2.circle(frame, (right_ear_x, right_ear_y), 5, (255, 255, 0), 3)
    except:
        pass

    try:
        left_cheek = result.multi_face_landmarks[0].landmark[234]
        left_cheek_x = int(left_cheek.x * image_width)
        left_cheek_y = int(left_cheek.y * image_height)
        valid_points["left_cheek"] = True
        cv2.circle(frame, (left_cheek_x, left_cheek_y), 5, (255, 0, 0), 3)
    except:
        pass

    try:
        right_cheek = result.multi_face_landmarks[0].landmark[454]
        right_cheek_x = int(right_cheek.x * image_width)
        right_cheek_y = int(right_cheek.y * image_height)
        valid_points["right_cheek"] = True
        cv2.circle(frame, (right_cheek_x, right_cheek_y), 5, (255, 0, 0), 3)
    except:
        pass


    #Sets up Face Height and Face Width Variables
    face_height = 0
    face_width = 0

    #Loops over the detected faces (only 1)
    for i, face in enumerate(faces):

        # Gets details like with width and height of the face

        x = face['facial_area']['x']
        y = face['facial_area']['y']
        w = face['facial_area']['w']
        h = face['facial_area']['h']

        face_height = h
        face_width = w

        # Crops the face to necessary area

        cropped_face = frame[y:y+h, x:x+w]
        if cropped_face.shape[0] < 100 or cropped_face.shape[1] < 100:
            cropped_face = cv2.resize(cropped_face, (100, 100))

        # Predicts age od face
        analysis = DeepFace.analyze(cropped_face, actions=['age'], enforce_detection=False)


        # Displays prediction
        cv2.rectangle(frame, (x,y), (x+w, y+h), (0, 0, 255), 2)
        cv2.putText(frame, f"Age: {analysis[0]['age']}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 0, 255), 2)      

    # Check if landmarks around the face exist, if they do, add their history (x and y coords)
    # and remove oldest frame if limit exceeded
    # Deletes previous frames in certain landmark not detected so frames are continuous

    if valid_points['chin']:
        y_chin_history.append(chin_y)
        x_chin_history.append(chin_x)
        if len(y_chin_history) > max_history:
            y_chin_history.pop(0)
            x_chin_history.pop(0)

    elif not valid_points['chin']:
        y_chin_history.clear()
        x_chin_history.clear()

    if valid_points['nose']:
        y_nose_history.append(nose_y)
        x_nose_history.append(nose_x)
        if len(y_nose_history) > max_history:
            y_nose_history.pop(0)
            x_nose_history.pop(0)

    elif not valid_points['nose']:
        y_nose_history.clear()
        x_nose_history.clear()

    if valid_points['forehead']:
        y_forehead_history.append(forehead_y)
        x_forehead_history.append(forehead_x)
        if len(y_forehead_history) > max_history:
            y_forehead_history.pop(0)
            x_forehead_history.pop(0)

    elif not valid_points['forehead']:
        y_forehead_history.clear()
        x_forehead_history.clear()


    if valid_points['left_ear']:
        y_left_ear_history.append(left_ear_y)
        x_left_ear_history.append(left_ear_x)
        if len(y_left_ear_history) > max_history:
            y_left_ear_history.pop(0)
            x_left_ear_history.pop(0)

    elif not valid_points['left_ear']:
        y_left_ear_history.clear()
        x_left_ear_history.clear()

    if valid_points['right_ear']:
        y_right_ear_history.append(right_ear_y)
        x_right_ear_history.append(right_ear_x)
        if len(y_right_ear_history) > max_history:
            y_right_ear_history.pop(0)
            x_right_ear_history.pop(0)

    elif not valid_points['right_ear']:
        y_right_ear_history.clear()
        x_right_ear_history.clear()

    if valid_points['left_cheek']:
        y_left_cheek_history.append(left_cheek_y)
        x_left_cheek_history.append(left_cheek_x)
        if len(y_left_cheek_history) > max_history:
            y_left_cheek_history.pop(0)
            x_left_cheek_history.pop(0)

    elif not valid_points['left_cheek']:
        y_left_cheek_history.clear()
        x_left_cheek_history.clear()

    if valid_points['right_cheek']:
        y_right_cheek_history.append(right_cheek_y)
        x_right_cheek_history.append(right_cheek_x)
        if len(y_right_cheek_history) > max_history:
            y_right_cheek_history.pop(0)
            x_right_cheek_history.pop(0)

    elif not valid_points['right_cheek']:
        y_right_cheek_history.clear()
        x_right_cheek_history.clear()


    # Sets up variable horizontal threshold based on face_width_ratio

    face_width_ratio = face_width / 640  
    face_width_ratio = np.clip(face_width_ratio, 0.3, 1.0)

    horizontal_threshold = 0.05 + 0.03 * (1 - face_width_ratio)


    #Checks the X Movement between the right and left side of the head:
    shake_detected = False

    if (len(x_left_ear_history) == max_history and
        len(x_right_ear_history) == max_history and
        len(x_left_cheek_history) == max_history and
        len(x_right_cheek_history) == max_history):

        # Compute movement range for each side
        dx_left_ear = np.max(x_left_ear_history) - np.min(x_left_ear_history)
        dx_right_ear = np.max(x_right_ear_history) - np.min(x_right_ear_history)

        dx_left_cheek = np.max(x_left_cheek_history) - np.min(x_left_cheek_history)
        dx_right_cheek = np.max(x_right_cheek_history) - np.min(x_right_cheek_history)

        # Normalize by face width
        dx_left_ear /= face_width
        dx_right_ear /= face_width
        dx_left_cheek /= face_width
        dx_right_cheek /= face_width

        # Check if both ears and both cheeks are moving significantly
        if (dx_left_ear > horizontal_threshold and dx_right_ear > horizontal_threshold and
            dx_left_cheek > horizontal_threshold and dx_right_cheek > horizontal_threshold):
            
            shake_detected = True
            print("Head Shake Detected")
            movement_dict['headshake'] += 1
            cv2.putText(frame, "Shake Detected", (x+150, y), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 255), 2)



    motion_scores = []

    # Sets up Variable vertical_threshold based on how large the face is on the frame
    face_height_ratio = face_height / 480
    face_height_ratio = np.clip(face_height_ratio, 0.3, 1.0)
    vertical_threshold = 0.05 + 0.03 * (1-face_height_ratio)

    # Checks if appropriate frame history recorded for chin, nose and forehead points, then based on thresholds records a nod
    if len(y_chin_history) == max_history:
        dy_chin = np.diff(y_chin_history) / face_height
        dx_chin = np.diff(x_chin_history) / face_width
        v_chin = np.max(dy_chin) - np.min(dy_chin)
        h_chin = np.max(dx_chin) - np.min(dx_chin)
        if v_chin > vertical_threshold and h_chin < horizontal_threshold*0.6:
            motion_scores.append('chin')

    if len(y_nose_history) == max_history:
        dy_nose = np.diff(y_nose_history) / face_height
        dx_nose = np.diff(x_nose_history) / face_width
        v_nose = np.max(dy_nose) - np.min(dy_nose)
        h_nose = np.max(dx_nose) - np.min(dx_nose)
        if v_nose > vertical_threshold and h_nose < horizontal_threshold:
            motion_scores.append('nose')

    if len(y_forehead_history) == max_history:
        dy_forehead = np.diff(y_forehead_history) / face_height
        dx_forehead = np.diff(x_forehead_history) / face_width
        v_forehead = np.max(dy_forehead) - np.min(dy_forehead)
        h_forehead = np.max(dx_forehead) - np.min(dx_forehead)
        if v_forehead > vertical_threshold and h_forehead < horizontal_threshold:
            motion_scores.append('forehead')

    # If more y movement recorded from at least 2 of the 3 points, notes it down as a nod
    if len(motion_scores) >= 2:
        cv2.putText(frame, "Nod Detected", (x+150, y), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
        movement_dict["nod"] += 1
        print(f"Nod Detected with {motion_scores}")

    cv2.imshow("Frame", frame)

    key = cv2.waitKey(100)

    if key == ord('q'):
        break

print((movement_dict))
capture.release()
cv2.destroyAllWindows()
