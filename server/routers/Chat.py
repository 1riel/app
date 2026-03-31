import os
import sys

sys.path.append(os.getcwd())

from fastapi import *

from Environment import *

app = FastAPI(docs_url="/")


chat_names = []


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


@app.websocket("/room")
async def _(
    websocket: WebSocket,
):
    try:
        # accept the connection
        await websocket.accept()

        chat_names.append(websocket)

        for conn in chat_names:
            print(conn.client)

        # echo back the received messages
        while True:
            data = await websocket.receive_text()
            for conn in chat_names:
                await conn.send_text(f"{websocket.client}: {data}")

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python Application.py")
