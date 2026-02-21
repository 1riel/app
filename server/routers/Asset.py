import os
import sys

sys.path.append(os.getcwd())

from fastapi import *
from fastapi.responses import *
from fastapi.middleware.cors import *
from datetime import datetime

from PIL import Image
from io import BytesIO

from Environment import *
from server.utilities.Storage import Storage
from server.utilities.Token import Token


router = APIRouter()

s3 = Storage()
tk = Token()


@router.get("/")
async def _(
    p: str = Query(..., json_schema_extra={"example": "profile.jpg"}),
    w: int | None = Query(None),
    h: int | None = Query(None),
):
    try:

        # check if object exists
        if not s3.object_exists(BUCKET_NAME, p):
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        # get file extension
        ext = p.split(".")[-1].lower()

        # get object from s3
        data = s3.get_object(BUCKET_NAME, p)

        # load image
        content = data.read()

        # prepare byte stream
        bio = BytesIO()

        # open image from bytes
        image = Image.open(BytesIO(content))

        # make the background white for png images
        if ext in ["png"]:
            image_background = Image.new("RGB", image.size, (255, 255, 255))
            image_background.paste(image, mask=image.split()[-1])
            image = image_background

        # send original image
        if w is None or h is None:

            image.save(bio, format="JPEG")  # save image to byte array
            bio.seek(0)  # reset pointer to start

            # return Response(content=image_byte, media_type="image/jpeg")
            return StreamingResponse(
                bio,
                media_type="image/jpeg",
                headers={
                    "Cache-Control": "public, max-age=31536000",
                    # 1 day = 86400 seconds
                    # 1 week = 604800 seconds
                    # 1 month = 2592000 seconds
                    # 1 year = 31536000 seconds
                },
            )

        # send resized image
        if w is not None and h is not None:
            target_width = int(w)
            target_height = int(h)
            target_ratio = target_width / target_height

            # validate dimensions
            if target_width <= 0 or target_height <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # limit max dimensions to prevent abuse
            if target_width >= 10000 or target_height >= 10000:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # calculate target aspect ratio
            image_width, image_height = image.size
            image_ratio = image_width / image_height

            # if image is wider than target, crop the left and right
            if image_ratio > target_ratio:
                new_width = int(image_height * target_ratio)
                offset = (image_width - new_width) // 2
                box = (offset, 0, offset + new_width, image_height)
                image = image.crop(box)
            # if image is taller than target, crop the top and bottom
            else:
                new_height = int(image_width / target_ratio)
                offset = (image_height - new_height) // 2
                box = (0, offset, image_width, offset + new_height)
                image = image.crop(box)

            image = image.resize((target_width, target_height), resample=Image.LANCZOS)  # resize image to target dimensions
            image.save(bio, format="JPEG")  # save image to byte array
            bio.seek(0)  # reset pointer to start

            # save resized image to s3 for future requests
            s3.put_object(BUCKET_NAME, f"resized/{target_width}x{target_height}/{p}", bio.getvalue())

            return StreamingResponse(
                bio,
                media_type="image/jpeg",
                headers={
                    "Cache-Control": "public, max-age=31536000",  # 1 year = 31536000 seconds
                },
            )

        return Response(status_code=status.HTTP_400_BAD_REQUEST)

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
