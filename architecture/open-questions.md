Architecture — Open Questions

Questions surfaced while manifesting the nutrition domain design into tech-arch and product. These must be resolved before implementation.

⸻

Problem Classification

Hard Problems — need deep architectural focus, novel decisions, high-impact

1. Interaction model (Q1-3)
   Chat, structured, or hybrid defines the entire product and tech stack. No standard pattern for an "expert + tools" combination. Most products are either chat (ChatGPT) or structured (MyFitnessPal). The hybrid is uncharted.

2. Orchestration identity (Q12-13)
   This shapes the entire backend. How much does the LLM own vs the system? Too much LLM = expensive, unpredictable. Too little = rigid, dumb. The boundary between deterministic and judgment is the hardest architectural call.

3. Context assembly (Q6)
   The expert needs a coherent picture built from multiple stores (events, memories, config, user context). What goes into the LLM context window? It's a relevance + token budget problem. Too much = cost and noise. Too little = bad advice.

4. Multi-action orchestration (Q10)
   "I want to lose weight" requires assess → goal → plan → tracking. How does this chain execute? Who decides the sequence? How does the user experience it? No standard pattern exists for LLM-driven multi-step flows.

5. Observation computation (Q7)
   Deriving patterns from events (weekly averages, adherence trends, pattern detection) is a computation problem. When to compute, how to cache, how to surface — this sits between data engineering and product.

6. Policy enforcement with LLM (Q18)
   LLMs are non-deterministic. How do you reliably enforce "never recommend fasting for diabetics"? Pre-filtering context? Post-filtering output? Structured output validation? This is an open research problem.

7. Expert posture calibration
   The expertise doc says posture adapts to engagement level. How does the system actually detect and shift posture? This is both a product and ML problem.

8. Domain routing (Q14)
   Multi-domain readiness. How does the system decide which expert to invoke? How do experts coordinate? No standard pattern for multi-agent domain routing in consumer products.

⸻

Medium Problems — known patterns exist but need product-specific decisions

9. Proactivity channel (Q4-5)
   Push notifications, in-app cards, scheduled digests — patterns exist. The hard part is WHAT to surface WHEN, which is a product design + expertise judgment call.

10. Session/conversation model (Q8)
    Chat apps have history. Structured apps are stateless. Hybrid needs a decision. Patterns exist but the right choice depends on Q1-3.

11. Artifact lifecycle in UX (Q11)
    Versioning, superseding, history — patterns exist (Git, Google Docs, etc). Need to decide what level of history the user sees.

12. Cross-domain context (Q15)
    Nutrition needs to know about fitness. Defined interfaces (APIs, shared context stores) are standard. The hard part is deciding WHAT to share.

13. Real-time vs async (Q17)
    Standard architectural decision. Most things live. Reviews and observations can be async/scheduled.

⸻

Paint by Numbers — well-understood, standard engineering

14. Data storage model (Q20)
    Relational DB + event store. Well-understood patterns. Choice of Postgres vs Mongo vs DynamoDB is implementation detail.

15. User config / settings
    Standard CRUD. Settings page. Stored in DB.

16. Event storage
    Immutable event log. Standard pattern (append-only table, event sourcing if ambitious).

17. Mobile offline (Q16)
    Offline-first with sync queue. Standard pattern. Complexity is manageable.

18. API layer (Q21)
    REST or GraphQL between frontend and backend. Standard.

19. LLM data access (Q21)
    Preload relevant context into prompt + tool-calling for specific queries. Patterns exist (LangChain, function calling).

20. Policy transparency (Q19)
    "I can't recommend this because..." — standard explainability pattern. Template-based responses for known policy triggers.

⸻
⸻

Detailed Questions

⸻

Interaction Model

1. Is the primary interface chat-based, structured UI, or hybrid?
   The expertise doc reads like a conversation partner. But tools (LogMeal, BuildMealPlan) feel like structured UI. These imply different architectures.

2. Where does the expert live?
   Always present (persistent chat)? Summoned (a button, a card)? Ambient (surfaces insights/recommendations without being asked)?

3. Do states (Learn, Plan, Do, Analyze) manifest visibly in UX?
   Are they tabs/screens/modes? Or invisible, with the system inferring the user's state?

⸻

Proactivity

4. When and how does the system reach out?
   Push notification? In-app card? Chat message? Scheduled digest?

5. What's the proactivity channel for async expertise?
   "Every Sunday, generate a weekly review" — where does that appear?

⸻

Context and Data

6. Who assembles context before each interaction?
   Is there a "context builder" that queries all stores and constructs the expert's input? Or does the LLM query as needed?

7. When are observations computed?
   "Recomputed, not persisted." On every request? Nightly batch? Event-driven (new meal logged → recompute averages)?

8. What's the session/conversation model?
   Persistent conversation history? Or stateless interactions with context loaded from stores?

⸻

Tool Execution

9. How do tools actually execute?
   The expert "wants" to build a meal plan. Does the LLM generate it directly? Or call a structured API that does computation (calorie fitting, preference matching)?

10. Multi-action chains — how do they manifest?
    User says "I want to lose weight." System needs to: assess → set goal → suggest plan → enable logging. Is this a wizard? A conversation? Auto-setup with confirmation?

⸻

Artifact Lifecycle

11. How does artifact versioning appear in UX?
    MealPlan is "active → superseded." Does the user see versions? Or just the latest? Goal gets "revised" — is there history?

⸻

Orchestration Identity

12. Is orchestration a component, a fabric, or the LLM itself?
    A) The LLM IS the orchestrator — reads context, decides, calls tools, returns.
    B) A backend service mediates — decides WHEN to invoke LLM, with WHAT context, does WHAT with output. LLM is one skill.
    C) Not a component — it's the pattern of how all parts connect.

13. If orchestration is a backend service, what's deterministic vs judgment?
    Deterministic: context assembly, tool execution, policy enforcement, event storage.
    Judgment: what to recommend, how to communicate, when to adapt.

⸻

Multi-Domain Readiness

14. Domain routing — who decides which expert to invoke?
    User says "I want to eat better AND train for a marathon." Two domains. Is there a router above domain experts?

15. Cross-domain context — how do domains share information?
    Nutrition expert needs to know about fitness activity. Fitness expert needs to know about caloric intake. What's the interface?

⸻

Mobile / Offline

16. Can the user act without connectivity?
    Log a meal offline. When does it sync? Can the expert work without network?

17. What's the real-time vs async split?
    Expert always responds live? Or can some things be background-computed?

⸻

Policy Enforcement

18. Where does policy enforcement happen?
    Before the LLM sees the request? After the LLM generates output? Both? Is there a policy filter layer?

19. How transparent is policy to the user?
    "I can't recommend fasting because you have diabetes" — does the system explain its constraints?

⸻

Data Architecture

20. What's the storage model?
    Relational DB? Document store? Event store? Combination? What's the source of truth for each context type (events, config, memories, observations)?

21. How does the LLM access domain data?
    Direct DB access? API layer? Preloaded into prompt? RAG retrieval?
