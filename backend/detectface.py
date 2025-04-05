from deepface import DeepFace
import cv2
import json

# Load the video 
capture = cv2.VideoCapture("IMG_6168.MOV")


# Read the video frame by frame
while True:
    # Returns ret = true if the frame exists and numpy array of image
    ret, frame = capture.read()

    if not ret:
        break

    cv2.imshow("Debug Frame", frame)

    # faces = DeepFace.extract_faces(frame, enforce_detection=False)

    # if not faces:
    #     print("No Faces detected")
    #     continue

    # for i, face in enumerate(faces):
    #     analysis = DeepFace.analyze(face['face'], actions=['age', 'gender','emotion'])

    #     print(f"Age: {analysis[0]['age']}, Gender: {analysis[0]['gender']}, Emotion: {analysis[0]['Emotion']}")

    #     x,y,w,h = face['facial_area']
    #     cv2.rectangle(frame, (x,y), (x+w, y+h), (0, 255, 0), 2)
    #     cv2.putText(frame, f"Age: {analysis[0]['age']}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

        
    # cv2.imshow("Frame", frame)

    # Optional: Wait for key press to continue to the next frame
    key = cv2.waitKey(1)  # Wait for 1 ms before continuing

    if key == ord('q'):  # Press 'q' to quit
        break  # Exit the loop if 'q' is pressed

capture.release()
cv2.destroyAllWindows()
