from fastapi import FastAPI


app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}


def open_browser():
        import webbrowser
        port = 8000
        webbrowser.open(f"http://localhost:{port}")

open_browser()
        