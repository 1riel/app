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
from server.utilities.Database import Mongo_DB

# from server.utilities.Debug import debug

router = APIRouter()
oa = OAuth2PasswordBearer(tokenUrl="token")
db = Mongo_DB()


@router.post("/create", deprecated=0)
async def _():
    try:
        blank_data = {"created_at": datetime.now()}

        await db.c_product.insert_one({**blank_data})

        return True
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# todo: add limit and offset
@router.post("/read", deprecated=0)
async def _():
    try:
        products = await db.c_product.find().limit(10000).to_list(length=None)

        return json.loads(json_util.dumps(products))
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/delete", deprecated=0)
async def _(
    id: str = Form(..., json_schema_extra={"example": ""}),
):
    try:
        await db.c_product.delete_one({"_id": ObjectId(id)})

        return True
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update", deprecated=0)
async def _(
    id: str = Form(..., json_schema_extra={"example": ""}),
    name: str | None = Form(None, json_schema_extra={"example": ""}),
    description: str | None = Form(None, json_schema_extra={"example": ""}),
    price: float | None = Form(None, json_schema_extra={"example": ""}),
    unit_price: str | None = Form(None, json_schema_extra={"example": ""}),
):
    try:

        if name is not None:
            await db.c_product.update_one({"_id": ObjectId(id)}, {"$set": {"name": name}})

        if description is not None:
            await db.c_product.update_one({"_id": ObjectId(id)}, {"$set": {"description": description}})

        if price is not None:
            await db.c_product.update_one({"_id": ObjectId(id)}, {"$set": {"price": price}})

        if unit_price is not None:
            await db.c_product.update_one({"_id": ObjectId(id)}, {"$set": {"unit_price": unit_price}})

        if any(v is not None for v in [name, description, price, unit_price]):
            await db.c_product.update_one({"_id": ObjectId(id)}, {"$set": {"updated_at": datetime.now()}})

        return True

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload", deprecated=1)
async def _():
    try:
        return True
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/search", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
