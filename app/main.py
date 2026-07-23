from fastapi import FastAPI

app = FastAPI(title="M-Motors API", version="1.0.0")

@app.get("/")
async def root():
    return {"message": "HELLO WORLD"}