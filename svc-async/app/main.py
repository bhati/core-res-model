from fastapi import FastAPI
from app.routes.cron import router as cron_router

app = FastAPI(title="svc-async", version="0.1.0")

app.include_router(cron_router)


@app.get("/health")
async def health():
    return {"status": "ok", "service": "svc-async"}
