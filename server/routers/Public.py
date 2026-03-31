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
from utilities.Storage import storage as s3
from utilities.Token import token as tk


router = APIRouter()


@router.get("/{p:path}")
async def _(
    p: str = Path(..., json_schema_extra={"example": "assets/background.png"}),
    w: int | None = Query(None),
    h: int | None = Query(None),
):
    try:

        # check if object exists
        if not s3.object_exists(MINIO_PUBLIC, p):
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        # get file extension
        ext = p.split(".")[-1].lower()

        # get object from s3
        data = s3.get_object(MINIO_PUBLIC, p)

        # load image
        content = data.read()

        # prepare byte stream
        bio = BytesIO()

        # open image from bytes
        image = Image.open(BytesIO(content))

        # make the background white for png images
        # if ext in ["png"]:
        #     image_background = Image.new("RGB", image.size, (255, 255, 255))
        #     image_background.paste(image, mask=image.split()[-1])
        #     image = image_background

        # send original image
        if w is None or h is None:
            image.save(bio, format="PNG")  # save image to byte array
            bio.seek(0)  # reset pointer to start

            # return Response(content=image_byte, media_type="image/jpeg")
            return StreamingResponse(
                bio,
                media_type="image/png",
                headers={
                    "Cache-Control": "public, max-age=2592000",
                },
            )

        # send resized image
        if w is not None and h is not None:

            # calculate target aspect ratio
            target_ratio = w / h

            # validate dimensions
            if w <= 0 or h <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # limit max dimensions to prevent abuse
            if w >= 10000 or h >= 10000:
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

            image = image.resize((w, h), resample=Image.LANCZOS)  # resize image to target dimensions
            image.save(bio, format="PNG")  # save image to byte array
            bio.seek(0)  # reset pointer to start

            return StreamingResponse(
                bio,
                media_type="image/png",
                headers={
                    "Cache-Control": "public, max-age=2592000",
                    # 1 day = 86400 seconds
                    # 1 week = 604800 seconds
                    # 1 month = 2592000 seconds
                    # 1 year = 31536000 seconds
                },
            )

        return Response(status_code=status.HTTP_400_BAD_REQUEST)

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python Application.py")
