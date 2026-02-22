# svc-async

Resonic async service — event processing + scheduled jobs. FastAPI.

## What it does

- Event consumption (pgmq — deferred)
- Event evaluation (does this event require action?)
- Observation engine (events → metrics → reports → observations)
- Scheduled job handling (cron triggers)

Does NOT call LLM directly — goes through svc-orchestra.

## Run

```bash
cp .env.example .env   # fill in your keys
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
uvicorn app.main:app --reload --port 8001
```

## Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/health` | Health check |
| POST | `/cron/daily` | Daily recalculation trigger (stub) |
| POST | `/cron/weekly` | Weekly review trigger (stub) |
