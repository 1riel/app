import time
import hmac
import hashlib
from typing import Optional, Dict, Any

from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import HTMLResponse
import jwt


app = FastAPI()


@app.get("/", response_class=HTMLResponse)
async def home():
    # server from index.html
    data = open("index.html").read()
    return HTMLResponse(content=data)


from urllib.parse import urlparse, parse_qs


@app.get("/auth/telegram")
async def telegram_auth(request: Request):

    url = str(request.url)
    parsed = urlparse(url)
    qs = parse_qs(parsed.query, keep_blank_values=True)

    # parse_qs returns lists; flatten to single values
    data = {k: v[0] for k, v in qs.items()}

    print(data)

    return request.query_params


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("001:app", reload=True)
