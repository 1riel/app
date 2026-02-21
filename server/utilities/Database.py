import os
import sys

sys.path.append(os.getcwd())


from typing import *
from pymongo import AsyncMongoClient

from Environment import *


class MongoDB:

    _client = AsyncMongoClient(
        DATABASE_URL,
        connectTimeoutMS=5000,  # 5 second timeout for initial connection
        serverSelectionTimeoutMS=5000,  # 5 second timeout for server selection
    )

    _db = _client["database"]

    async def list_collection_names(self):
        return await self._db.list_collection_names()

    c_credential = _db["c_credential"]

    c_credential_reset_otp = _db["c_credential_reset_otp"]
    c_credential_signup_otp = _db["c_credential_signup_otp"]

    c_product = _db["c_product"]
    c_store = _db["c_store"]
    c_driver = _db["c_driver"]
