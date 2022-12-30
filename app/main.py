from fastapi import FastAPI
from starlette.responses import RedirectResponse

from fastapi.staticfiles import StaticFiles
from starlette.responses import FileResponse, JSONResponse, StreamingResponse

import os

NOCACHE_HEADERS={"Cache-Control": "no-cache, no-store, must-revalidate", "Pragma": "no-cache", "Expires": "0"}

# check the os type if its linux , if linux then save env variable in current shell with DEBUG=True
if os.name == 'posix':
    UI_PATH = 'app/ui'
else:
    UI_PATH = os.getenv('UI_PATH', None)

server_api = FastAPI()
server_api.mount("/", StaticFiles(directory=UI_PATH,html=True), name="static")








def open_browser():
        import webbrowser
        port = 8000
        webbrowser.open(f"http://localhost:{port}")


# @server_api.get('/')
# def index():
#         return RedirectResponse(url='/index.html')


# @server_api.get('/')
# def index():
#         return RedirectResponse(url='/index.html')

# open_browser()
        
