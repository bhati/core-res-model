User Journeys

Bottom-up design: concrete user flows that will inform LLM pipeline, client architecture, and orchestration.

⸻

Inventory

Ordered by criticality to the core nutrition loop.

1. Onboarding — cold start
   First run. Collect FactAttributes, set dietary/allergy exclusions, set first Goal. End state: system has enough context to be useful.

2. Meal Logging — the daily core
   User records what they ate. All input modes: structured, plan-confirmed, prose, binary. Entity resolution, confidence, refinement. The most frequent interaction.

3. Goal Setting — establishing direction
   User declares what they want. LLM assesses, suggests targets, creates config side effects. Activates policy priors. May be part of onboarding or standalone.

4. Meal Plan Building — the Plan loop
   System generates a plan from Goal + context + memories. User reviews, adjusts, accepts. Triggers ShoppingList/CookingPlan.

5. Day View — the daily surface
   Mixed-granularity view of today: logged meals, pending plan items, confidence indicators, daily totals vs targets. The wireframe we sketched.

6. Weekly Review — the Analyze loop
   MacroReview + MealReview generated. User sees how the week went. Feeds back into plan adjustment or goal revision.

7. Quick Chat — the Learn surface
   User asks a nutrition question. Conversational, no artifact produced. Expertise answers with context.

⸻

Each journey file will define:
- Trigger (what starts this journey)
- Steps (user actions + system responses)
- Data touched (entities read/written)
- LLM calls (what the LLM does at each step)
- Edge cases
- Exit conditions

⸻

Deferred journeys (not MVP):
- Recipe creation / import
- Shopping list management
- Cooking plan execution
- Goal revision (reuse Goal Setting with predecessor logic)
- Milestone celebrations
- Circumstance declaration
