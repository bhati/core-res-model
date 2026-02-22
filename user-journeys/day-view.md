Day View

⸻

Part 1: What Is This Surface?

The Day View is not a journey — it's the primary surface that multiple journeys operate on. It's where the user lands daily. It hosts meal logging (batch surface), plan rendering (suggestions and committed slots), daily progress, and content-fill insights.

But its purpose is not yet decided.

⸻

The Mega Question: What is the Day View for?

Option A: Summary View
A read-heavy dashboard. "Here's how your day is going." The user checks in, sees progress, moves on. Logging and planning happen elsewhere.

Option B: Action Hub
An interaction-heavy surface. The user DOES things here — logs meals, confirms plan, refines entries. The Day View is where work happens.

Option C: Branching View
A navigation surface. The user sees their day at a glance, then taps into journeys: tap a meal slot → logging, tap progress → insights, tap plan → planning. The Day View is a menu, not a destination.

Option D: Living Document
The Day View is the primary artifact — a continuously evolving record of the day. It starts empty/suggested in the morning and ends as a complete log by night. The user's job is to progressively fill it. Both summary and action.

Each option implies different UX weight, information density, and interaction patterns.

⸻

What It Assembles

The Day View composes data from multiple sources:

  Meal slots     → MealPlan (suggestions/committed) + MealLogs (recorded)
  Progress       → MealLogs aggregated vs NutritionGoal targets
  Daily summary  → Content fill (LLM-generated prose from data)
  Slot actions   → Triggers to HP05a composition or plan-confirm

⸻

Key Design Questions

Identity:
1. Is this the app home or one tab among others (home, plan, chat, profile)?
2. Does this screen exist for past days too, or only today? If past days, is it the same layout?
3. Is there a separate "history" view, or is Day View + date navigation the history?

Slot model:
4. Where do meal slots come from when plan_enabled is false? Does the system impose structure (breakfast/lunch/dinner), or does the user just see a blank page with [+ log]?
5. How does the slot model flex for non-3-meals users (OMAD, 6 small meals, grazers)?
6. Snacks — are they their own slot(s) or an "other" bucket?

Zero states:
7. No plan + no logs + no goal → what does the user see? This is the absolute cold start.
8. No plan + no logs + has goal → progress bars at zero, empty slots? Not motivating.
9. Plan exists + no logs (morning) → strong zero state (plan is the content). Best case.
10. Plan exists + all logged (evening) → summary mode. What's the value of returning?

Progress:
11. Do progress bars appear only when targets exist (body_composition, medical) or always?
12. Exploratory users — no targets. No progress bars. What fills that space?
13. Confidence-weighted progress — if lunch was logged at 0.5 confidence, are the kcal shown as approximate?

Content:
14. Daily summary — is it always present, or earned after N logs? "Solid day" means nothing with 1 logged meal.
15. Insights — should individual insights surface here ("you eat more on weekends") or only in weekly review?

Time progression:
16. How does the surface change throughout the day? Morning = future-facing (planned). Evening = past-facing (logged). Same layout?
17. End-of-day: should the system prompt for any unlogged slots? "You didn't log dinner — skip or forgot?"

Navigation:
18. Swipe between days? Calendar picker? How does the user access previous days?
19. Tap on a logged meal → what happens? View detail? Open for refinement? Nothing?
20. Where does "start a chat" live relative to Day View?
