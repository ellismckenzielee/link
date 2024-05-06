from fastapi import FastAPI

app = FastAPI()


@app.get("/authorize")
async def authorize_get():
    return {"route": "authorize - GET"}

@app.post("/authorizer")
async def authorize_post():
    return {"route": "authorize - POST"}

@app.get("/token")
async def token():
    return {"route": "token - GET"}

