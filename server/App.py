import os
import sys


sys.path.append(os.getcwd())


from fastapi import *
from fastapi.responses import *
from fastapi.middleware.cors import *

from Environment import *

# from server.routers import Asset
from server.routers import Home
from server.routers import Credential
from server.routers import Product


app = FastAPI(title="1Riel Backend API", version="1.0.0", docs_url="/")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])


# app.include_router(Asset.router, prefix="/assets", tags=["Asset"])
app.include_router(Credential.router, prefix="/credential", tags=["Credential"])
app.include_router(Product.router, prefix="/product", tags=["Product"])
app.include_router(Home.router, prefix="/home", tags=["Home"])


if __name__ == "__main__":

    import os
    import uvicorn
    import platform

    if platform.node() == "msl-t470":  # deploy on server

        module_name = os.path.relpath(os.path.abspath(__file__), os.getcwd()).replace("\\", ".").replace("/", ".")[:-3]
        variable_name = "app"

        uvicorn.run(
            f"{module_name}:{variable_name}",
            host="127.0.0.1",
            port=8000,
            workers=6,  # check cpu core: lscpu
        )

    else:  # local server

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
            reload_includes=["sources_application/**"],
            reload_excludes=["__pycache__"],
        )
