Work State

Last updated: 2026-02-22

⸻

1. Stale Files (need update)

File                        Issue
nutrition-model.md          Meal entity, Goal→NutritionGoal, Review→NutritionReview, tool definitions
user-context-nutrition.md   Old config fields, traits terminology, intent taxonomy alignment
implementation-notes.md     Tracks 11 specific stale items across above files + engineering-blocks

⸻

2. Architecture Open Questions

Hard (parked for later)

  AQ1. Domain routing — multi-domain: which expert to invoke?                    (parked)
  AQ2. Cross-domain context — how domains share information                      (parked)

Medium (partially answered by journey work)

  AQ3. Proactivity channel — HOW: WYLO cards ✓, push notifications still TBD
  AQ4. Artifact lifecycle in UX — partially: MealPlan + NutritionGoal have lifecycles, full versioning UX TBD
  AQ5. Policy transparency — partially: HP05b makes policy visible in goal-setting, general-purpose TBD

Paint by numbers

  AQ6. Data storage model
  AQ7. Mobile offline
  AQ8. Real-time vs async
  AQ9. API layer

New from journey work

  AQ10. Chat placement — RESOLVED: Notes tab (auto-processed post-its)
  AQ11. Events architecture — RESOLVED: pgmq + svc-events
  AQ12. WYLO priority model — which containers, what order?
  AQ13. Zoom slider vs segmented tabs — touch target viability

⸻

3. Navigation Open Questions

  NQ1. Chat placement (= AQ10)
  NQ2. WYLO priority logic (= AQ12)
  NQ3. Timeline ↔ WYLO overlap — are they deeply linked or independent?
  NQ4. Browse for exploratory users — richer views needed?
  NQ5. Cross-domain You — all domains combined or domain-by-domain?
  NQ6. Notification-driven entry — push opens WYLO or Timeline?

⸻

4. Day View Design Questions (20 listed, proposal resolves some)

Resolved by proposal:
  DQ1-3 (identity) — Timeline tab, past days accessible, no separate history
  DQ18-19 (navigation) — ◀▸ for days, tap to zoom
  DQ16 (time progression) — same layout, content shifts

Still open:
  DQ4. Slot source when plan_enabled: false — RESOLVED: 3-slot default template, user-configurable
  DQ5. Non-3-meal users (OMAD, grazers) — RESOLVED: 7 predefined slots + custom
  DQ6. Snacks — RESOLVED: predefined slots include mid-day bite, evening snack, late night
  DQ7-10. Zero states — see known concerns below
  DQ11-13. Progress bars — when to show, exploratory users, confidence weighting
  DQ14-15. Content fill timing — daily summary after N logs? Insights here or weekly only?
  DQ17. End-of-day prompt — "You didn't log dinner — skip or forgot?"
  DQ20. Chat entry point — RESOLVED: Notes tab is the input surface

⸻

5. Known Concerns by Journey

Log a Meal:
  LC1. Cold start — no plan + no history = worst first experience
  LC2. Batch prose — multi-meal parsing from one input underspecified
  LC3. Navigation cost of [✎] — 3 edits = 3 round trips
  LC4. Refinement overkill — simple quantity edit shouldn't need full HP05a
  LC5. Day view assumes meal slots — RESOLVED: configurable slot template

Set a Goal:
  GC1. Assessment depth — too many questions feels clinical
  GC2. Multi-intent decomposition — 3 primary tags on one goal vs prioritization
  GC3. Target transparency — WHY 1800 kcal was suggested
  GC4. Validation tone — firm but not preachy

Build a Plan:
  PC1. Token cost of rolling suggestions — throttling for free-tier?
  PC2. Cold start suggestion quality — generic without patterns
  PC3. Week view complexity — 21+ slots on mobile
  PC4. Adaptation vs stability — small deviations shouldn't trigger changes
  PC5. Suggestion explainability — "why paneer tikka?"

⸻

6. Product Principles Open Questions

  PP1. Circumstance creation policy — declared, inferred, or conversational?
  PP2. Memory expiry — do memories decay if contradicted?
  PP3. Emotional safety — product-level dimensions of emotional harm?
  PP4. Multi-user — shared contexts (family meal planning)?

⸻

7. Nutrition Domain Open Questions

  ND1. Wellbeing/energy as intent category?
  ND2. Dietary identity / life stage as category?
  ND3. Multi-select across intent categories — interaction model?
  ND4. Performance intents — nutrition or future fitness taxonomy?
  ND5. Circumstance creation policy (= PP1)
  ND6. HP03: context scope mismatch mid-conversation — resolution TBD

⸻

8. HP04 TBDs

  HP4a. Extraction validation, confirmation flows, confidence thresholds — now partially addressed by HP05a composition call pattern
  HP4b. Re-scoping mid-conversation, escalation to broader context — not addressed

⸻

Summary Counts

  Category                Count  Resolved/Partial  Truly Open
  Architecture questions    13         5                8
  Navigation questions       6         2                4
  Day View questions        20       ~10              ~10
  Journey concerns          14         1               13
  Product principles         4         0                4
  Nutrition domain           6         0                6
  HP04 TBDs                  2         1                1
  Stale files                3         0                3
  ─────────────────────────────────────────────────────────
  Total                     68       ~19              ~49
