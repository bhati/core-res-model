HP02 — Observation Computation

⸻

1. Problem

The context model defines Events → Observations → Memories. Events are immutable records. Memories are durable stabilized truths. Observations sit in between — derived understanding computed from events. When to compute them, what to compute, and who computes them is an architectural question.

⸻

2. Position

Deterministic Reports, Dual-Rendered Observations.

A deterministic computation layer produces reports and metrics from events. These are pre-defined, recomputable, and cacheable. Examples: weekly nutrition summary, meal item frequency analysis, goal adherence by week, user session cohorting.

Reports compress raw events into pattern-level metrics. The LLM never reads raw events. It reads computed metrics.

⸻

3. Dual Rendering

Each observation has two renderings of the same insight:

Numerical — for code paths: { avg_protein: 62, target: 130, delta_pct: -52 }
Prose — for LLM consumption: "Average protein this week: 62g against a 130g target (-52%)"

Both are deterministic. Both derive from the same report. The insight is identical.

Code paths use numerical rendering for thresholds, UI elements, dashboards.
LLM uses prose rendering as context input for judgment (what to say, what to recommend, what to surface).

⸻

4. Bounded Observable Universe

The LLM can only observe what reports and metrics present it. If no report exists for a particular cross-cut, it is not in the LLM's observable universe.

The observable universe grows by adding new reports — defined by the user or the system — not by giving the LLM more raw data.

This is an intentional constraint. Pattern detection is curated, not emergent.

⸻

5. Lifecycle

Reports are recomputed (event-driven or periodic — implementation choice).
Observations are always fresh — derived from the latest report data.
Observations do not need a staging area — they are analytical, not speculative.

Memory promotion — when the LLM's judgment based on observations should become a durable memory — is an implementation choice, not a hard architectural problem.

⸻

6. Architecture

Events
    ↓
Reports / Metrics (deterministic, recomputed)
    ↓
Observations (dual rendering: numerical + prose)
    ↓
Code paths read numerical  |  LLM reads prose + context → judgment
