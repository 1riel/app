import os
import sys


sys.path.append(os.getcwd())


from fastapi import *
from fastapi.responses import *
from fastapi.middleware.cors import *

from Environment import *


from routers.Product import router as product
from routers.Credential import router as credential
from routers.Home import router as home
from routers.Store import router as store
from routers.CRUD import router as crud


# initialize database and storage
import Initialization


app = FastAPI(title=TITLE, version="1.0.0", docs_url="/")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])


app.include_router(store, prefix="/store", tags=["Store"])
app.include_router(credential, prefix="/credential", tags=["Credential"])
app.include_router(product, prefix="/product", tags=["Product"])
app.include_router(home, prefix="/home", tags=["Home"])
app.include_router(crud, prefix="/crud", tags=["CRUD"])


if __name__ == "__main__":

    import os
    import uvicorn
    import webbrowser
    from threading import Timer

    def open_browser():
        webbrowser.open("http://127.0.0.1:8000")

    Timer(1, open_browser).start()

    module_name = os.path.relpath(os.path.abspath(__file__), os.getcwd()).replace("\\", ".").replace("/", ".")[:-3]
    variable_name = "app"

    uvicorn.run(
        f"{module_name}:{variable_name}",
        host="127.0.0.1",
        port=8000,
        reload=True,
        reload_includes=[
            "server/routers/*.py",
            "server/utilities/*.py",
            "server/Application.py",
            "server/Environment.py",
        ],
        reload_excludes=["__pycache__"],
    )
