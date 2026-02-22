Navigation Architecture

Four top-level surfaces, one zoom model, and one composition pattern.

⸻

Top-Level Tabs

  [ Where You Left Off ]  [ Timeline ]  [ Browse ]  [ You ]

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
- Review card → Generated review surface
- Goal card → You tab (goal settings)
- Plan card → Timeline or HP05a composition

This is where reviews come to the user — not a tab, not a zoom level. A card that appears when generated.

No fixed layout. Containers appear, disappear, and reorder based on priority and time of day.

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

3. Browse

The structural navigation surface. Not time-based — entity-based. Tree traversal.

Purpose: "I want to find something specific."

  Browse:
  ├── Foods — my food library, search, filter
  ├── Recipes — saved recipes, create new
  ├── Plans — active plan, past plans
  ├── Goals — active goal, goal history
  ├── Logs — all meal logs, filterable by date/meal/source
  └── Reviews — generated review artifacts

Each entry point opens a list/detail view. Standard navigation — search, filter, sort, tap to open.

Multi-domain ready: when fitness arrives, Browse gets a domain selector or a top-level domain split.

⸻

4. You

The identity surface. Who am I to this system?

Purpose: manage self — goals, preferences, configuration.

  You:
  ├── Active Goal
  │   Statement, tags, targets
  │   [Revise goal]
  ├── Intents (active)
  ├── Preferences
  │   Dietary exclusions, allergy exclusions
  │   Memories (constraints, preferences, observations)
  ├── Configuration
  │   Plan settings (enabled, window, reactivity)
  │   Tracking granularity
  │   Notification preferences
  ├── Attributes
  │   Weight, height, sex, activity level
  │   Medical conditions
  └── Domains
      Nutrition: active
      Fitness: coming soon

Editing any field opens an inline editor or HP05a composition for complex changes (goal revision).

⸻

Tab Responsibilities

  Tab                    What it does              What it doesn't do
  Where You Left Off     Resume, act on what's new  Store permanent content
  Timeline               Navigate time, log meals   Recommend or suggest
  Browse                 Find entities by structure  Show temporal patterns
  You                    Manage identity, config    Show data or actions

⸻

Open Questions

1. Chat placement. Where does freeform conversation live?
   Options: floating button (everywhere), card in Where You Left Off,
   mode within HP05a, fifth tab. Not decided.

2. Where You Left Off priority logic. How does the system decide which
   containers to show and in what order? Needs a priority model.

3. Timeline ↔ Where You Left Off overlap. "Log your lunch" card on
   Where You Left Off navigates to Timeline. Are these deeply linked
   or independent surfaces?

4. Browse for exploratory users. Users with goal: exploratory may use
   Browse heavily (exploring their data). Does Browse need richer
   views for this persona?

5. Cross-domain You. When fitness arrives, does You show all domains
   combined or domain-by-domain? Active intents span domains.

6. Notification-driven entry. Push notification "Log your dinner" →
   opens which tab? Where You Left Off or directly to Timeline?
