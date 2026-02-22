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

⸻

Part 2: Proposal

Decision: Option D — Living Document.

The Day View is a continuously evolving record of the day. Solid structure, dynamic content. Everything is tappable (zoom in), nothing is directly actionable on the overview. Actions surface in zoomed views.

Interaction model: todo list.
- Tap row → zoom into meal detail (action pills surface here)
- Swipe right → quick confirm (ate as planned)
- Swipe left → quick skip
- [Select] mode → multi-select for batch confirm/skip
- Zoom out → week / month / year

⸻

Wireframe: Day View (midday — mixed states)

  ┌──────────────────────────────────────────┐
  │  ◀  Sat, Feb 22                    ▸     │
  │                                [Select]  │
  ├──────────────────────────────────────────┤
  │                                          │
  │  "On track — 900 of 1800 kcal so far."  │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │  ◉  ☀ Breakfast · logged       ●●●      │
  │     Overnight oats + coffee              │
  │     382 kcal                             │
  │                                          │
  │  ◉  🌤 Lunch · logged          ●●○      │
  │     "had dal rice and salad"             │
  │     ~520 kcal                            │
  │                                          │
  │  ○  🌙 Dinner · planned                  │
  │     Paneer tikka + roti                  │
  │     ~650 kcal                            │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │  Calories  ██████░░░░░░  902 / 1800     │
  │  Protein   █████░░░░░░░  68 / 120g      │
  │                                          │
  ├──────────────────────────────────────────┤
  │  Y ─── M ─── W ─── ◉D ─── +Add         │
  └──────────────────────────────────────────┘

  ○ = unlogged (planned/suggested)
  ◉ = logged
  ⊘ = skipped
  ●●● = high confidence  ●●○ = medium  ●○○ = low

  Swipe right on row → quick confirm (ate as planned)
  Swipe left on row  → quick skip
  Tap row            → zoom to meal card
  ◀ ▸                → navigate between days
  [Select]           → multi-select mode for batch

⸻

Wireframe: Week View (slide to ◉W — meals at week scale)

  ┌──────────────────────────────────────────┐
  │  ◀  Week of Feb 17–23              ▸    │
  │                                          │
  ├──────────────────────────────────────────┤
  │                                          │
  │  "Consistent Mon–Thu. Friday outlier."   │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │        Mo    Tu    We    Th    Fr   Sa   │
  │  ☀    ◉oats ◉oats ◉oats ◉oats ◉eggs ○  │
  │  🌤   ◉dal  ◉salad◉wrap ◉dal  ◉pizza○  │
  │  🌙   ◉tikka◉soup ◉rice ◉pasta⚠burg ○  │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │  Meal routines:                          │
  │  · Breakfast: oats 4/5 days             │
  │  · Lunch: dal 2x — variety?             │
  │  · Fri dinner: 800 kcal — outlier       │
  │                                          │
  │  Adherence: 4/6 days on plan             │
  │  Logged: 18/21 meals                     │
  │                                          │
  ├──────────────────────────────────────────┤
  │  Y ─── M ─── ◉W ─── D ─── +Add         │
  └──────────────────────────────────────────┘

  Tap any cell → zoom to that meal card
  Tap day column → zoom to that day view
  ◀ ▸ → navigate between weeks

⸻

Wireframe: Meal Card (tapped lunch — HP05a structure section)

  ┌──────────────────────────────────────────┐
  │  ◀ Back to day                           │
  ├──────────────────────────────────────────┤
  │                                          │
  │  🌤 Lunch · Sat, Feb 22                  │
  │  Status: logged · ●●○                    │
  │  Source: prose_extracted                  │
  │  raw: "had dal rice and salad"           │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │   Dal          1 serving    ~180 kcal    │
  │   Rice         1 serving    ~260 kcal    │
  │   Salad        1 serving    ~80 kcal     │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │   Total                     ~520 kcal    │
  │   Protein 18g · Carbs 72g · Fat 12g     │
  │                                          │
  │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
  │                                          │
  │   [Refine portions]                      │
  │   [Edit items]                           │
  │   [Delete log]                           │
  │                                          │
  └──────────────────────────────────────────┘

  For an unlogged planned slot, pills would be:
  [✓ Ate this]  [✎ Had something else]  [✗ Skip]

  Tapping [✎ Had something else] or [Edit items] opens the
  full HP05a composition surface (structure + assistant + input).
  The meal card IS the structure section of HP05a — it becomes
  the top section, with assistant and input appearing below.

⸻

Zoom Slider

  Y ─── M ─── W ─── ◉D ─── +Add

  Persistent bottom bar. Current level highlighted with ◉.
  Slide or tap to change zoom level. +Add opens HP05a composition.

  Level   Primary content            Content fill
  Meal    Items, portions, macros    (none — this is the detail)
  Day     Meal slots for one day     Daily summary
  Week    Meal grid (7 × slots)     Meal routines, adherence
  Month   Condensed meal patterns    Dietary trends
  Year    Meal routine evolution     Long-term habits

  Weekly Review is not a separate journey — it's the ◉W zoom level.
