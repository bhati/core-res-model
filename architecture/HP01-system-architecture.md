HP01 — System Architecture

⸻

1. Problem

The system has two kinds of capability: conversational (assessment, explanation, empathy) and structured (meal plans, logs, goals, reviews). Existing products pick one side — chat-first (ChatGPT) or entity-first (MyFitnessPal). The question is how this system is architecturally organized.

⸻

2. Position

Entity/Memory First — LLM for Pathways and Skill.

Three approaches exist:

Entity-first SaaS — Entities + hard-coded pathways. LLM augments deterministic flows.
Chat-first — Conversation is primary. Memories, tools, artifacts bolt on to give chat persistence.
This system — Entities and memories are the source of truth. LLM drives product pathways and provides domain expertise.

The data architecture is entity/memory-first: Food, Meal, MealPlan, MealLog, Goal, observations, memories are first-class structured objects. They live in a database. They are the ground truth.

But the pathways between entities are not hard-coded. The LLM drives navigation, judgment, and expertise.

⸻

3. Surfaces

Surfaces are hard shells with LLM-filled content.

Hard shell — pre-built structure: layout, navigation, component slots, entity schema. Examples: home ("continue where you left off"), entity browser, timeline view, user profile.

LLM content — what fills the slots. Generated at render time or pre-processed on events. What the user sees, how things are framed, what's emphasized, what's communicated.

There is no separate "chat interface" vs "structured interface." Every surface is a hard shell. The LLM fills the content within it. When the LLM needs to talk to the user directly (assessment, empathy, explanation), that conversation happens within a surface — it is not a separate mode.

⸻

4. Three LLM Roles

Fill — Populate content slots on hard surfaces. Some at render time, some pre-processed on events. Examples: home screen insights, review summaries, plan descriptions.

Judge — Provide expertise judgment within tool workflows. Tools (BuildMealPlan, LogMeal, SetGoal) are deterministic system paths with entity operations. The LLM provides the judgment within those paths — what to recommend, how to assess, what to emphasize.

Route — Decide what surface or step the user sees next. Based on composed context (entities + memories + config + user context), the LLM determines the next interaction surface.

⸻

5. Execution Loop

User acts on surface (hard shell, entity interaction)
    ↓
System composes context (entities + memories + config + user context)
    ↓
LLM reads context, applies judgment (expertise + policy)
    ↓
System writes results (entity mutations, memory updates — validated)
    ↓
LLM determines next surface and fills content
    ↓
System renders surface
    ↓
User acts...

The system mediates between LLM judgment and entity state. The LLM never writes directly to the entity layer.

⸻

6. Pressure-Tested Scenarios

Cold start — User lands on a hard bootstrap surface (onboarding = attribute/config/declared memory collection). LLM enters once enough context exists to judge. First surface is product-defined, not LLM-routed.

Multi-step intent ("I want to lose weight") — LLM bounces between LLM-filled surfaces naturally: assessment questions → goal setting (pre-filled by LLM) → plan building. Works cleanly.

Returning user (context-rich) — User lands on entity home (active plan, log status, goal progress). LLM fills ambient content (insights, nudges) based on proactivity config. No explicit action needed to start the loop — LLM fills the home surface with context-aware content.

Policy enforcement (diabetic requests fasting) — System composes context including medical attributes. LLM catches policy concern within tool workflow. Surface switches to LLM communication explaining why, with empathy. Model is strong here.

⸻

7. Open Problem: Prose ↔ Structure Handoff

When the LLM talks to the user (prose) and the user responds, that response must become structure (entities, memories, config). When structured entity state needs to be surfaced to the user, it must become prose.

Prose → Structure: structured extraction. "I'm vegetarian and I avoid eggs" → dietary_type: vegetarian + memory: "avoids eggs."
Structure → Prose: contextual generation. calorie_target: 1800 + protein_avg: 62g → "Your protein has been running low this week."

Both are within LLM capability. The architectural question is validation and reliability at the prose → structure boundary.

⸻

8. What This Is Not

This is not chat-first. The user does not live in a conversation. They live among their entities.
This is not traditional SaaS with LLM bolted on. The LLM is not augmenting hard-coded flows — it drives pathways and provides expertise.
This is not a fixed product. The surface sequence is context-dependent, not pre-determined. But every surface is a pre-built hard shell.

⸻

9. Interaction Design

TBD — Interaction design (how surfaces look, feel, and flow) is a separate problem from system architecture. This document defines the system. Interaction design builds on top of it.
