import os
import sys


sys.path.append(os.getcwd())


from typing import *
from fastapi import *

from datetime import datetime
import json
from bson import ObjectId, json_util

from Environment import *
from utilities.Database import database as db
from utilities.Bearer import bearer as oa

router = APIRouter()


@router.post("/create", deprecated=0)
async def _(
    #
    access_token: str = Depends(oa),
):
    try:

        user = await db["c_credential"].find_one({"access_token": access_token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        data = {
            "owner_id": user["_id"],
            "created_at": datetime.now(),
            "updated_at": None,
            "deleted_at": None,
        }

        # check if store already exists
        existing_store = await db["c_store"].find_one({"owner_id": ObjectId(user["_id"]), "deleted_at": None})
        if existing_store:
            return "Store already exists"

        await db["c_store"].insert_one({**data})

        return "Store created successfully"
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# @router.post("/read", deprecated=0)
def read_all(query: str = None):
    if query:

        async def _():
            try:
                stores = (
                    await db["c_store"]
                    .find(
                        {
                            "deleted_at": None,
                            "name": {"$regex": query, "$options": "i"},
                        }
                    )
                    .to_list(None)
                )
                return json.loads(json_util.dumps(stores))
            except Exception as e:
                return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return _

    async def _():
        try:
            stores = (
                await db["c_store"]
                .find(
                    {
                        "deleted_at": None,
                    }
                )
                .to_list(None)
            )
            return json.loads(json_util.dumps(stores))
        except Exception as e:
            return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)

    return _


router.post("/read", deprecated=0)(read_all())


COLLUMN_STRINGS = [
    "name",
    "description",
    "address",
]


key = "name"


def update_string(key: str):
    async def _(
        access_token: str = Depends(oa),
        value: str = Form(..., json_schema_extra={"example": ""}),
    ):
        try:

            user = await db["c_credential"].find_one({"access_token": access_token})
            if not user:
                return Response(status_code=status.HTTP_401_UNAUTHORIZED)

            await db["c_store"].update_one(
                {"owner_id": ObjectId(user["_id"])},
                {"$set": {key: value, "updated_at": datetime.now()}},
            )

            return 1
        except Exception as e:
            return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)

    return _


# router.post(f"/update/{key}", deprecated=0)(update_string(key))
for key in COLLUMN_STRINGS:
    router.post(f"/update/{key}", deprecated=0)(update_string(key))


COLLUMN_IMAGES = [
    "profile",
    "background",
]

# todo: upload image

if __name__ == "__main__":
    os.system("python Application.py")
