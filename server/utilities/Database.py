import os
import sys

sys.path.append(os.getcwd())


from pymongo import AsyncMongoClient
from rich import print as pprint

from Environment import *


# NOTE: database and collection are automatically created.

client = AsyncMongoClient(
    MONGO_URL,
    connectTimeoutMS=5000,  # 5 second
    serverSelectionTimeoutMS=5000,  # 5 second
)

database = client[MONGO_DATABASE]


if __name__ == "__main__":
    import asyncio

    async def main():
        data = await database["c_credential"].find_one({})
        pprint(data)

    asyncio.run(main())
