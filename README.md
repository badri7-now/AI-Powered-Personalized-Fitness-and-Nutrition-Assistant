# AI-Powered Personalized Fitness and Nutrition Assistant

A mobile application built with **React Native (Expo)**, **Node.js/Express**, and **PostgreSQL / Supabase** featuring **FitAI Coach** — an AI assistant designed to personalize workouts, meal nutrition, and progress tracking.

---

## 📱 App Highlights & Architecture

- **Clean Modern Health UI**: White + Ice Blue (`#FFFFFF`, `#F0F4F8`, `#0077FF`, `#102A43`) with full Light & Dark mode support.
- **FitAI Coach**: Interactive conversational AI coach equipped with user profile awareness, suggested questions, and medical safety guardrails.
- **Personalized AI Workout Generator**: Tailors routine to equipment (Home/Gym), fitness level, duration, and target muscles.
- **Live Interactive Workout Player**: Real-time set/rep/weight logging, elapsed timer, and interactive countdown Rest Timer.
- **Offline Workout Logging & Auto-Sync**: Logs workouts locally when offline; automatically synchronizes with deduplication when connectivity returns.
- **Personalized Nutrition & Meal Planner**: Dynamic breakfast, lunch, dinner, and snack curation matching caloric targets, dietary preferences (Veg, Vegan, Non-Veg), and food allergies.
- **Mifflin-St Jeor Calorie Calculator**: Calculates estimated BMR, TDEE, and goal-adjusted calorie and macro targets.
- **Health Connect & HealthKit Integration**: Abstraction layer for Google Health Connect (Android) and Apple HealthKit (iOS) with step and active calorie tracking.
- **Enterprise-Grade Security**: Password hashing with bcrypt, JWT token authentication, secure token storage, and database Row Level Security (RLS) policies.

---

## 📁 Project Structure

```
ai-fitness-nutrition-app/
├── backend/                  # Node.js + TypeScript Express API
│   ├── src/
│   │   ├── config/           # Database abstraction (Supabase + Local SQLite/JSON)
│   │   ├── controllers/      # Auth, Profile, Workouts, Nutrition, Progress, AI
│   │   ├── middleware/       # JWT Auth verification
│   │   ├── routes/           # REST endpoints
│   │   ├── services/         # FitAI Coach, Calorie Calc, Nutrition Generator
│   │   └── server.ts         # Server entry point
│   ├── data/                 # Local persistent storage
│   ├── test-api.js           # Automated integration test suite (10/10 tests)
│   └── package.json
├── frontend/                 # React Native / Expo Mobile App
│   ├── src/
│   │   ├── api/              # API Client with offline fallback
│   │   ├── components/       # Card, Button, Header, ProgressRing, RestTimer, WaterTracker, WeeklyCalendar
│   │   ├── context/          # AuthContext, ThemeContext, SyncContext, HealthContext
│   │   ├── screens/          # Splash, Login, Register, ForgotPassword, ProfileSetup,
│   │   │                     # Dashboard, AICoach, WorkoutGenerator, ActiveWorkout,
│   │   │                     # WorkoutHistory, Nutrition, Progress, Profile
│   │   ├── theme/            # Colors (#FFFFFF, #F0F4F8, #0077FF, #102A43), Typography
│   │   └── types/            # TypeScript interfaces
│   ├── App.tsx               # Central Navigation, Auth routing & Bottom Tabs
│   └── app.json
└── supabase/
    └── migrations/
        └── 01_initial_schema.sql  # SQL schema with Row Level Security (RLS)
```

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- **Node.js**: v20+
- **npm**: v10+

### 2. Start the Backend API
```bash
cd backend
npm install
npm start
```
The server will boot on `http://localhost:5000`.

To run the automated 10-point test suite:
```bash
node test-api.js
```

### 3. Launch the Mobile App (Expo)
```bash
cd frontend
npm install

# To preview in your web browser:
npm run web

# To run on Android device / emulator:
npm run android

# To run on iOS device / simulator:
npm run ios
```

---

## 🔒 Security & Row Level Security (RLS)

If connecting to Supabase / PostgreSQL in production, execute the migration located at:
`supabase/migrations/01_initial_schema.sql`

This creates:
- `profiles`
- `workouts`
- `workout_exercises`
- `nutrition`
- `progress`

Each table has **Row Level Security (RLS)** strictly enforced:
```sql
CREATE POLICY "Users can manage own workouts" ON public.workouts
    FOR ALL USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
```

---

## 🤖 Configuring FitAI Coach

By default, FitAI operates using its intelligent built-in rule and reasoning engine at **zero cost** without requiring any paid subscriptions.

To enable live Google Gemini API or OpenAI generation:
1. Open `backend/.env`
2. Add your key:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   # or
   OPENAI_API_KEY=your_openai_api_key_here
   ```
3. Restart the backend server.
