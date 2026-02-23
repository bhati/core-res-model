from fastapi import FastAPI
from app.routes.health import router as health_router
from app.routes.cron import router as cron_router

app = FastAPI(title="svc-async", version="0.1.0")

app.include_router(health_router)
app.include_router(cron_router)
