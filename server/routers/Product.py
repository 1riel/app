import os
import sys

sys.path.append(os.getcwd())


from typing import *
from fastapi import *
from fastapi.security import *
from fastapi.responses import *

import json
from datetime import datetime
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

        blank_data = {"created_at": datetime.now()}

        await db["c_product"].insert_one({**blank_data})

        return True
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/read", deprecated=0)
async def _(
    query: str = Form("", json_schema_extra={"example": ""}),
    offset: int = Form(0, json_schema_extra={"example": 0}),
    limit: int = Form(1000, json_schema_extra={"example": 1000}),
):
    try:
        # fmt: off
        search = ( 
            await db["c_product"]
                    .find({"name": {"$regex": query, "$options": "i"}})
                    .skip(offset)
                    .limit(limit)
                    .to_list(length=None)
        )
        # fmt: on

        return json.loads(json_util.dumps(search))

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# create need access token
# read don't need access token
# update need access token
# delete need access token

if __name__ == "__main__":
    os.system("python Application.py")
