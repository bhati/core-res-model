Navigation Architecture

Four top-level surfaces, one zoom model, and one composition pattern.

⸻

Top-Level Tabs

  [ Where You Left Off ]  [ Timeline ]  [ Notes ]  [ Browse ]

⸻

1. Where You Left Off

The dynamic home surface. Computed on every open. Structured containers that surface the most relevant next action.

Purpose: answer "what should I do right now?"

Containers are event-driven — system assembles from current state:

  Unlogged meals         → "Log your lunch ▸"
  Plan suggestion ready  → "Tonight: paneer tikka ▸"
  Review generated       → "Your week in review ▸"
  Goal milestone         → "5 days on protein target ▸"
  Stale plan             → "Plan was built for travel. Rebuild? ▸"
  Onboarding incomplete  → "Tell me your goal ▸"
  Low confidence logs    → "Refine yesterday's dinner? ▸"

Each container links to its destination:
- Meal card → Timeline (day view, zoomed to that meal)
- Review card → generated review surface
- Goal card → Browse (goal settings)
- Plan card → Timeline or HP05a composition

This is where reviews come to the user — not a tab, not a zoom level. A card that appears when generated.

No fixed layout. Containers appear, disappear, and reorder based on priority and time of day.

Zero state (new user): WYLO becomes the onboarding surface. No data to resume, so containers guide setup: "Tell me your goal ▸", "Any dietary restrictions? ▸", "Log your first meal ▸". Onboarding is not a separate journey — it's WYLO when there's nothing to resume.

⸻

2. Timeline

The temporal surface. Calendar-based. This IS the Day View with zoom.

Purpose: navigate through time, see meals at any scale.

Zoom slider at bottom:

  Y ─── M ─── W ─── ◉D ─── +Add

  Day (◉D)    Meal slots, daily summary, progress bars
  Week (W)    Meal grid (7 × slots), routines, adherence
  Month (M)   Condensed meal patterns, dietary trends
  Year (Y)    Meal routine evolution, long-term habits

  +Add → opens HP05a composition surface for a new meal log

Interaction:
- Tap row → zoom to meal card (action pills surface there)
- Swipe right → quick confirm (ate as planned)
- Swipe left → quick skip
- [Select] → multi-select for batch confirm/skip
- ◀ ▸ → navigate between days/weeks/months

The meal card IS the HP05a structure section. Tapping [Edit] opens the full composition surface (structure + assistant + input).

⸻

3. Notes

The delegation surface. Auto-processed post-its. User writes short natural-language notes; system classifies intent, routes to the right tool, shows outcome. Not a chat — not a conversation.

Purpose: shortcuts. Quick input from any context without navigating.

Metaphor: post-it notes that auto-process. Short, no response expected, outcome-oriented.

How it works:

  User writes:             System does:                  Surface shows:
  "had coffee"             LogMeal(coffee)               ✓ Coffee · 45 kcal · logged
  "skip lunch"             SkipMeal(lunch)               ✓ Lunch skipped
  "plan tomorrow"          BuildMealPlan(day)             → Opens plan in Timeline
  "no eggs anymore"        AddExclusion(eggs)             ✓ Eggs added to exclusions
  "feeling sick"           SetCircumstance(sick)          ✓ Noted. Plan adjusted.
  "72 kg"                  UpdateAttribute(weight)        ✓ Weight updated · 72 → 72 kg
  "paneer was great"       NoteObservation(preference)    ✓ Preference noted

Design rules:
1. No thread. Each note is independent. No scrolling conversation history.
2. Outcome cards, not prose replies. Show what changed, not "I've done that for you!"
3. Processed notes fade or archive. Surface is always mostly empty.
4. Placeholder cues show examples: "had coffee" · "skip lunch" · "72 kg" · "no eggs"
5. Ambiguous input → one-shot clarification, not conversation.
6. Non-actionable input (questions, emotions) → brief answer card, no thread.
7. Multi-domain ready: "ran 5k" works when fitness arrives.

LLM call type: Tool Judgment. One-shot classification + execution. Not Composition (no multi-turn). Not Conversational (no thread).

What this solves:
- Chat placement question → Notes replaces chat. User has a fast input surface.
- HP04 risk → eliminated. No conversation thread means no context drift.
- Shortcut problem → user can log from Notes without navigating to Timeline.
- System personality → expressed through competence (parsing accuracy), not through replies.

⸻

4. Browse

The structural navigation surface. Entity-based tree traversal. Now includes identity (absorbed from former You tab).

Purpose: "I want to find or manage something specific."

  Browse:
  ├── Me
  │   ├── Active Goal (statement, tags, targets, [Revise])
  │   ├── Intents (active)
  │   ├── Preferences (exclusions, memories)
  │   ├── Attributes (weight, height, conditions)
  │   └── Configuration (plan settings, tracking, notifications)
  ├── Foods — my food library, search, filter
  ├── Recipes — saved recipes, create new
  ├── Plans — active plan, past plans
  ├── Logs — all meal logs, filterable
  └── Reviews — generated review artifacts

"Me" is the top-level entry that replaced the former You tab. Identity and config are browseable data — just another branch of the entity tree.

Each entry point opens a list/detail view. Standard navigation — search, filter, sort, tap to open.

Multi-domain ready: when fitness arrives, Browse gets a domain layer.

⸻

Tab Responsibilities

  Tab                    What it does                What it doesn't do
  Where You Left Off     Resume, act on what's new   Store permanent content
  Timeline               Navigate time, see meals    Recommend or suggest
  Notes                  Quick delegation, shortcuts  Hold conversations
  Browse                 Find/manage entities + self  Show temporal patterns

⸻

Open Questions

1. WYLO priority logic. How does the system decide which containers to show and in what order?

2. Timeline ↔ WYLO overlap. "Log your lunch" card on WYLO navigates to Timeline. How deeply linked?

3. Notes ambiguity handling. "What should I eat?" — is this a question (answer card) or an instruction (generate suggestion)? Classification rules needed.

4. Browse for exploratory users. Richer views for users who spend more time exploring data?

5. Cross-domain Browse. When fitness arrives — domain selector or merged tree?

6. Notification-driven entry. Push notification "Log your dinner" → opens which tab?
