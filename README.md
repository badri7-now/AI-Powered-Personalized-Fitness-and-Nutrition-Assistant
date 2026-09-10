# AI Fitness & Nutrition Assistant

Complete-from-zero project: Expo React Native mobile app + Node.js REST API + Supabase PostgreSQL/Auth.

## Mobile
```bash
cd mobile
npm install
npx expo start
```
Copy `.env.example` to `.env` and set `EXPO_PUBLIC_SUPABASE_URL`, `EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY`, and `EXPO_PUBLIC_API_URL`.

## Backend
```bash
cd backend
npm install
npm run dev
```
Set `PORT`, `AI_API_URL`, `AI_API_KEY`, and `AI_MODEL` if an AI provider is available. Without those values, safe deterministic fallback responses are used.

## Database
Run `supabase/schema.sql` in Supabase SQL Editor. RLS policies restrict rows to the authenticated user.
