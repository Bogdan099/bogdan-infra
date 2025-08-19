from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "🚂 Railway deployment successful!", "status": "running"}

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "orchestrator"}

if __name__ == "__main__":
    import uvicorn
    import os
    port = int(os.getenv("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port)
