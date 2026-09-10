# AI-Powered Personalized Fitness and Nutrition Assistant

Production-oriented responsive web application for personalized workouts, nutrition, progress tracking and AI wellness coaching.

## Stack
- Next.js + React + TypeScript
- Tailwind CSS
- Supabase Auth, PostgreSQL and Storage-ready architecture
- Gemini primary AI with OpenAI fallback and rule-based fallback
- Recharts and Lucide React

## Important architecture
This repository is a **web application**. React Native and Expo are not used. Next.js hosts both the UI and server API route handlers, so a separate Render backend is not required.

## Features
- Email/password and Google OAuth authentication
- Secure username-to-email resolution on the server
- Onboarding and editable profile
- Personalized workout generation and execution
- Exercise library and workout history
- Nutrition generation and local food database/logging
- Calorie estimation using Mifflin-St Jeor
- Progress logging and charts
- FitAI Coach with Gemini -> OpenAI -> rule-based fallback
- Notification preferences
- Light/dark/system appearance
- Admin role-protected metrics endpoint
- Supabase RLS for user-owned records
- Responsive desktop/tablet/mobile UI

## Setup
1. Create a Supabase project.
2. Run `supabase/schema.sql` in the Supabase SQL Editor.
3. Enable Email auth and configure Google OAuth in Supabase Auth.
4. Copy `.env.example` to `.env.local` and fill in the values.
5. Install dependencies: `npm install`
6. Start development: `npm run dev`
7. Build: `npm run build`
8. Start production: `npm start`

## Environment variables
`NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` are browser-safe Supabase values.
`SUPABASE_SERVICE_ROLE_KEY` is server-only and must never be exposed to client code.
`GEMINI_API_KEY` and `OPENAI_API_KEY` are server-only. `AI_PROVIDER=gemini` selects Gemini first; set it to `openai` to reverse the priority.
`EMAIL_PROVIDER` and `EMAIL_API_KEY` are reserved for an email provider implementation; the app does not crash when email is unconfigured.

## Google OAuth
In Supabase Authentication > Providers, enable Google and add the Supabase callback URL supplied by your project. Add your Vercel production URL and local URL to the allowed redirect URLs. The app starts the OAuth flow from the login page.

## Admin
Create an admin role for a user from the Supabase SQL editor, for example:

```sql
insert into public.admin_roles(user_id, role) values ('AUTH_USER_UUID', 'admin');
```

Admin authorization is checked server-side; hiding the navigation item is not the security boundary.

## Deployment to Vercel
Import this GitHub repository into Vercel, set the environment variables in Project Settings, and deploy. The project uses Next.js API route handlers and does not require Render.

## Data and privacy
Fitness and nutrition records are private user data. RLS policies bind user-owned rows to `auth.uid()`. Do not put secrets in the repository. Do not commit `.env.local` or service-role keys.

## Safety
FitAI provides general wellness guidance and does not diagnose conditions or prescribe treatment. For injuries, severe pain, medical conditions or medication questions, users are directed to a qualified healthcare professional. Calorie burn and calorie targets are estimates, not medical prescriptions.

## Troubleshooting
- If login fails, verify Supabase Auth provider configuration and site/redirect URLs.
- If AI is unavailable, confirm server-side API keys. The workout and nutrition generators have a rule-based fallback.
- If data is missing, confirm `schema.sql` has been executed and that the logged-in user owns the requested records.
- If Vercel cannot build, run `npm run build` locally with the same Node major version and environment variables.
