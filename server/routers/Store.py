import os
import sys

sys.path.append(os.getcwd())


from fastapi import *

from Environment import *

app = FastAPI(docs_url="/")


@app.post("/q")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.post("/c")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.post("/r")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.post("/u")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@app.post("/d")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
