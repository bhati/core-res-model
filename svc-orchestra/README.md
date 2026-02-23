# svc-orchestra

Resonic orchestrator service — workflows + LLM pipeline. FastAPI.

## What it does

- Intent classification (Notes → which workflow?)
- Workflow execution (LogMeal, SetGoal, etc.)
- LLM pipeline (context assembly → prompt → LLM → structured output)
- Side effect coordination (Goal → config + memories)

## Infrastructure

- **Auth** — JWT validation via Supabase (`auth.py`)
- **Geolocation** — IP2Location for timezone/city context (`services/geolocation.py`)
- **SSE streaming** — Server-Sent Event formatting (`streaming/sse.py`)
- **Event recording** — Fire-and-forget events for async processing (`events/recorder.py`)

## Run

```bash
cp .env.example .env   # fill in your keys
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
uvicorn app.main:app --reload --port 8000
```

## Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/health` | Health check |
| POST | `/dispatch` | Main entry point (stub) |
