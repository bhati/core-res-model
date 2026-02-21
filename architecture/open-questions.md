Architecture — Open Questions

Questions surfaced while manifesting the nutrition domain design into tech-arch and product.

⸻

Resolved by Architecture Decisions

HP01 — System Architecture (entity/memory-first, LLM for pathways and skill)
  Resolves: Q1, Q2, Q6, Q8, Q9, Q10, Q12, Q13, Q18, Q21
  Partially resolves: Q4, Q7, Q19, Q20

HP02 — Observation Computation (deterministic reports, dual-rendered observations)
  Resolves: Q7 fully

HP03 — Context Scaling (surfaces scope context)
  Resolves: posture calibration (original hard problem #7)
  Partially resolves: Q4 (proactivity channel scoped per surface)

HP04 — Core Challenges (prose ↔ structure handoff, context drift)
  Marks as ongoing: two fundamental challenges at technology boundary

⸻

Remaining Open Questions

Hard — needs deep focus

1. Domain routing (Q14)
   Multi-domain readiness. How does the system decide which expert to invoke? How do experts coordinate? Parked — nutrition-first, multi-domain later.

2. Cross-domain context (Q15)
   How do domains share information? Defined interfaces needed. Parked with Q14.

⸻

Medium — known patterns, needs product decisions

3. Proactivity channel (Q4-5)
   WHAT to surface WHEN is partially addressed by HP03 (surface-scoped). HOW (push notification, in-app card, scheduled digest) remains a product design decision.

4. Artifact lifecycle in UX (Q11)
   Versioning, superseding, history — what the user sees. Interaction design.

5. Do states manifest visibly in UX? (Q3)
   Are Learn/Plan/Do/Analyze visible modes or invisible inference? Interaction design.

⸻

Paint by Numbers — standard engineering

6. Data storage model (Q20)
   Partially informed by HP01 (entities/memories are first-class in DB). Specific tech choices remain.

7. Mobile offline (Q16)
   Offline-first with sync queue. Standard pattern.

8. Real-time vs async (Q17)
   Most things live. Reviews and observations can be async/scheduled.

9. API layer
   REST or GraphQL between frontend and backend. Standard.

10. Policy transparency (Q19)
    Partially informed by HP01 (LLM can explain on a surface). Template patterns for known policy triggers.
