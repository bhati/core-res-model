# client-web

Resonic web client — React + Vite + Supabase.

## What it does

- 4-tab navigation: WYLO → Timeline → Browse → You
- Supabase Auth (session management)
- Supabase client (anon key — respects RLS)
- svc-orchestra calls (via VITE_ORCHESTRA_URL)

## Run

```bash
cp .env.example .env   # fill in your keys
npm install
npm run dev             # → http://localhost:5173
```

## Structure

```
src/
├── lib/supabase.js         ← Supabase client (anon key)
├── contexts/AuthContext.jsx ← Auth state provider
├── pages/                  ← Route pages
│   ├── Wylo.jsx
│   ├── Timeline.jsx
│   ├── Browse.jsx
│   └── You.jsx
├── App.jsx                 ← Router + bottom nav
└── main.jsx                ← Entry point
```
