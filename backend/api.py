from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import shutil, uuid, os, subprocess
import sys

app = FastAPI()

UPLOAD_DIR = "test_video"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/detect-nod")
async def detect_nod(video: UploadFile = File(...)):
    # Save the uploaded file
    file_id = str(uuid.uuid4())
    temp_path = f"{UPLOAD_DIR}/{file_id}.mp4"

    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(video.file, buffer)
    print("File saved to:", temp_path)
    # Call detectface.py with subprocess
    result = subprocess.run(
        [r"cv\Scripts\python.exe", "detectface.py", temp_path],
        capture_output=True,
        text=True
    )
    print("Subprocess completed with return code:", result.returncode)
    print("STDOUT:", result.stdout)
    print("STDERR:", result.stderr)

    os.remove(temp_path)

    if "NO_FACE" in result.stdout:
        return JSONResponse(status_code=400, content={"error": "No face detected."})
    if "SHAKE" in result.stdout:
        return JSONResponse(status_code=399, content={"error": "Kid Un-Approved!"})
    if "NOD" in result.stdout:
        return JSONResponse(status_code=250, content={"success": "Kid Approved!"})

    return JSONResponse(status_code=500, content={"error": "Unexpected response."})
