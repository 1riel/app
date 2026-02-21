import os
import sys

sys.path.append(os.getcwd())

# from server.utilities.Debug import debug


from pymongo import AsyncMongoClient
from typing import *

from server.Environment import *


class Mongo_DB:

    async def list_collection_names(self):
        return await self.db.list_collection_names()

    client = AsyncMongoClient(
        MONGO_URL,
        connectTimeoutMS=5000,  # 5 second
        serverSelectionTimeoutMS=5000,  # 5 second
    )

    db = client[MONGO_DATABASE]

    c_credential = db["c_credential"]
    c_credential_reset_otp = db["c_credential_reset_otp"]
    c_credential_signup_otp = db["c_credential_signup_otp"]

    c_attendance = db["c_attendance"]
    c_attendance_code = db["c_attendance_code"]

    c_class_name = db["c_class_name"]

    c_class_type = db["c_class_type"]

    c_contributor = db["c_contributor"]

    c_counter = db["c_counter"]

    c_template = db["c_template"]

    v_attendance = db["v_attendance"]


if __name__ == "__main__":
    import asyncio

    async def main():
        db = Mongo_DB()
        data = await db.c_credential.find_one({"username": "muysengly"})
        print(data)

    asyncio.run(main())
