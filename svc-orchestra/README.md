# svc-orchestra

Resonic orchestrator service — workflows + LLM pipeline. FastAPI.

## What it does

- Intent classification (Notes → which workflow?)
- Workflow execution (LogMeal, SetGoal, etc.)
- LLM pipeline (context assembly → prompt → LLM → structured output)
- Side effect coordination (Goal → config + memories)

## Run

```bash
cp .env.example .env   # fill in your keys
pip install -e .
uvicorn app.main:app --reload --port 8000
```

## Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/health` | Health check |
| POST | `/dispatch` | Main entry point (stub) |
