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
   WHAT to surface WHEN is partially addressed by HP03 (surface-scoped). HOW is now answered: Where You Left Off surface shows event-driven cards. Push notifications remain a product decision.

4. Artifact lifecycle in UX (Q11)
   Partially answered: MealPlan has lifecycle (suggestion → soft → committed → superseded). NutritionGoal has lifecycle (active → revised → retired). Day View shows artifact state via indicators. Full versioning UX still TBD.

5. Do states manifest visibly in UX? (Q3) — RESOLVED
   No. States (Learn/Plan/Do/Analyze) are invisible design scaffolding. Navigation is 4 tabs: Where You Left Off, Timeline, Browse, You. States dissolve into UX context signals per engineering-blocks.md Gap 1.

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
    Partially answered: HP05b validation gate makes policy visible during goal-setting. Block messages explain why. General-purpose policy explanation still TBD.

⸻

New Questions from Journey Work

11. Chat placement
    Where does freeform conversation live? Options: floating button, WYLO card, HP05a mode, fifth tab. Not decided.

12. Events architecture
    MealPlan listens to events for adaptation. WYLO assembles cards from events. No formal event spec exists — what events, who emits, who listens.

13. WYLO priority model
    How does the system decide which containers to show and in what order? Priority logic undefined.

14. Zoom slider vs segmented tabs
    Timeline zoom (Y-M-W-D-+Add) — slider is conceptually elegant but may be difficult as a touch target. Needs UX testing.
