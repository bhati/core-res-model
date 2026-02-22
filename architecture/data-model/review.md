Review

A structured analysis output. Snapshot in time.

- id
- user_id
- period: { start_date, end_date }
- type (summary / comparison / pattern)
- metrics_snapshot (the report data at review time — numerical)
- narrative (LLM-generated prose — the observation layer)
- observations: [{ content, type, evidence_count }]
- created_at

Immutable once created. Captures what was true and what the LLM assessed at that point.
