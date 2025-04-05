from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import shutil
import uuid
import os
import subprocess

app = FastAPI()

UPLOAD_DIR = "test_video"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/detect-nod")
async def detect_nod(video: UploadFile = File(...)):
    # Save uploaded video to a temp file
    file_id = str(uuid.uuid4())
    temp_path = f"{UPLOAD_DIR}/{file_id}.mp4"

    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(video.file, buffer)

    # Run your existing main.py as subprocess
    result = subprocess.run(["python", "main.py", temp_path], capture_output=True, text=True)

    print("Subprocess Output:", result.stdout)

    nod_detected = "True" in result.stdout

    # Clean up if you want
    os.remove(temp_path)

    return JSONResponse(content={"nod_detected": nod_detected})
