import os
import sys

sys.path.append(os.getcwd())


from fastapi import *

from Environment import *

router = APIRouter()


@router.post("/search", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/create", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/read", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/delete", deprecated=1)
async def _(
    #
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload", deprecated=1)
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
