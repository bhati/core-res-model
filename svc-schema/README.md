# svc-schema

Supabase database schema for Resonic. Cloud Supabase (not self-hosted).

## Tables (v0)

| # | Table | Migration | Description |
|---|---|---|---|
| 1 | `global_foods` | 000001 | System food catalog |
| 2 | `foods` | 000002 | User-scoped foods (override or standalone) |
| 3 | `global_meal_slots` | 000003 | 7 predefined meal slots with time ranges |
| 4 | `meal_slots` | 000004 | User-scoped slot config |
| 5 | `fact_attributes` | 000005 | Structured user context (EAV) |
| 6 | `prose_attributes` | 000005 | Prose user context (LLM-consumed) |
| 7 | `circumstances` | 000005 | Temporary conditions |
| 8 | `nutrition_goals` | 000006 | Tagged goal commitment |
| 9 | `meals` | 000007 | Eating occasions |
| 10 | `meal_items` | 000007 | Food items per meal |
| 11 | `events` | 000008 | Immutable event log |
| — | RLS policies | 000009 | Row-level security for all tables |

## Applying Migrations

To your cloud Supabase project:

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

Or paste individual migration files into the Supabase SQL editor.

## Design Decisions

See [scope-v0.md](scope-v0.md) for the full brainstorming log.
