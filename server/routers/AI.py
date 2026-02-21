import os
import sys

sys.path.append(os.getcwd())

import cv2
import numpy as np

from fastapi import *
from fastapi.responses import *
from insightface.app import FaceAnalysis

from Environment import *


app = FastAPI(docs_url="/")


fa = FaceAnalysis(name="buffalo_sc", root=f"{os.getcwd()}/sources_application", providers=["CPUExecutionProvider"])
fa.prepare(ctx_id=-1, det_thresh=0.5, det_size=(320, 320))


@app.post("/analyze_face")
async def _(
    input: UploadFile = File(..., description="Image file to analyze"),
):
    try:
        # Read the uploaded image file
        image_data = await input.read()

        # convert the byte data to a numpy array
        nparr = np.frombuffer(image_data, np.uint8)

        # decode the numpy array to an image
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # analyze the faces in the image
        faces = fa.get(img)

        # check no face detected
        if not faces:
            return JSONResponse(content={"error": "No face detected"}, status_code=400)

        # check multiple faces detected
        if len(faces) > 1:
            return JSONResponse(content={"error": "Multiple faces detected"}, status_code=400)

        # return bbox and embedding
        output = {
            "bbox": faces[0].bbox.tolist(),
            "embedding": faces[0].embedding.tolist(),
        }

        return output
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.post("/")
async def _(
    id: str = Form(..., json_schema_extra={"example": "694565ba3fb7ed6c8b10d85e"}),
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
