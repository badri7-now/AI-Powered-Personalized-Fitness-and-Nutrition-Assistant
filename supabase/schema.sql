create extension if not exists pgcrypto;

create table if not exists profiles (
 id uuid primary key default gen_random_uuid(), user_id uuid unique not null references auth.users(id) on delete cascade,
 name text not null default '', username text unique not null, age int, gender text, height numeric, weight numeric,
 fitness_level text, activity_level text, fitness_goal text, workout_preference text, available_workout_time int,
 workout_days_per_week int, preferred_workout_type text, equipment_available text[] default '{}', food_preference text,
 allergies text, dietary_preferences text, avatar_url text, onboarding_completed boolean not null default false,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists exercise_library (
 id uuid primary key default gen_random_uuid(), name text unique not null, muscle_group text not null, equipment text not null default 'None',
 difficulty text not null, instructions text not null, safety_notes text, created_at timestamptz not null default now()
);
create table if not exists workouts (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, workout_name text not null,
 date date not null default current_date, duration int, difficulty text, completed boolean not null default false, source text default 'manual',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists workout_exercises (
 id uuid primary key default gen_random_uuid(), workout_id uuid not null references workouts(id) on delete cascade,
 exercise_id uuid references exercise_library(id), exercise_name text not null, muscle_group text, sets int, reps int, weight numeric,
 duration int, rest_time int, completed boolean not null default false, order_index int not null, created_at timestamptz not null default now()
);
create table if not exists nutrition (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, date date not null default current_date,
 meal_type text not null, meal_name text not null, calories numeric default 0, protein numeric default 0, carbohydrates numeric default 0,
 fats numeric default 0, completed boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists food_items (
 id uuid primary key default gen_random_uuid(), name text unique not null, serving_size text not null, calories numeric not null default 0,
 protein numeric not null default 0, carbohydrates numeric not null default 0, fats numeric not null default 0, created_at timestamptz not null default now()
);
create table if not exists food_logs (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, food_item_id uuid references food_items(id),
 date date not null default current_date, serving_quantity numeric not null default 1, calories numeric not null default 0, protein numeric not null default 0,
 carbohydrates numeric not null default 0, fats numeric not null default 0, created_at timestamptz not null default now()
);
create table if not exists progress (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, date date not null default current_date,
 weight numeric, steps int, calories numeric, workout_duration int, created_at timestamptz not null default now(), unique(user_id,date)
);
create table if not exists ai_plans (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, type text not null,
 title text not null, content jsonb not null, metadata jsonb not null default '{}', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists notification_preferences (
 id uuid primary key default gen_random_uuid(), user_id uuid unique not null references auth.users(id) on delete cascade,
 workout_browser boolean default true, workout_email boolean default false, water_browser boolean default true, water_email boolean default false,
 meal_browser boolean default true, meal_email boolean default false, activity_browser boolean default true, activity_email boolean default false,
 streak_browser boolean default true, streak_email boolean default false, created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists user_settings (
 id uuid primary key default gen_random_uuid(), user_id uuid unique not null references auth.users(id) on delete cascade,
 theme text not null default 'light', created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists admin_roles (
 id uuid primary key default gen_random_uuid(), user_id uuid unique not null references auth.users(id) on delete cascade, role text not null default 'admin', created_at timestamptz default now()
);
create index if not exists workouts_user_date_idx on workouts(user_id,date desc);
create index if not exists nutrition_user_date_idx on nutrition(user_id,date desc);
create index if not exists food_logs_user_date_idx on food_logs(user_id,date desc);
create index if not exists progress_user_date_idx on progress(user_id,date desc);

alter table profiles enable row level security; alter table workouts enable row level security; alter table workout_exercises enable row level security;
alter table nutrition enable row level security; alter table food_logs enable row level security; alter table progress enable row level security;
alter table ai_plans enable row level security; alter table notification_preferences enable row level security; alter table user_settings enable row level security;
alter table admin_roles enable row level security; alter table exercise_library enable row level security; alter table food_items enable row level security;

do $$ declare t text; begin
 foreach t in array array['profiles','workouts','workout_exercises','nutrition','food_logs','progress','ai_plans','notification_preferences','user_settings'] loop
  execute format('drop policy if exists owner_select on %I',t); execute format('drop policy if exists owner_insert on %I',t); execute format('drop policy if exists owner_update on %I',t); execute format('drop policy if exists owner_delete on %I',t);
 end loop;
end $$;
create policy owner_select on profiles for select using (auth.uid()=user_id); create policy owner_insert on profiles for insert with check(auth.uid()=user_id); create policy owner_update on profiles for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on profiles for delete using(auth.uid()=user_id);
create policy owner_select on workouts for select using(auth.uid()=user_id); create policy owner_insert on workouts for insert with check(auth.uid()=user_id); create policy owner_update on workouts for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on workouts for delete using(auth.uid()=user_id);
create policy workout_exercises_owner on workout_exercises for all using(exists(select 1 from workouts w where w.id=workout_id and w.user_id=auth.uid())) with check(exists(select 1 from workouts w where w.id=workout_id and w.user_id=auth.uid()));
create policy owner_select on nutrition for select using(auth.uid()=user_id); create policy owner_insert on nutrition for insert with check(auth.uid()=user_id); create policy owner_update on nutrition for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on nutrition for delete using(auth.uid()=user_id);
create policy owner_select on food_logs for select using(auth.uid()=user_id); create policy owner_insert on food_logs for insert with check(auth.uid()=user_id); create policy owner_update on food_logs for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on food_logs for delete using(auth.uid()=user_id);
create policy owner_select on progress for select using(auth.uid()=user_id); create policy owner_insert on progress for insert with check(auth.uid()=user_id); create policy owner_update on progress for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on progress for delete using(auth.uid()=user_id);
create policy owner_select on ai_plans for select using(auth.uid()=user_id); create policy owner_insert on ai_plans for insert with check(auth.uid()=user_id); create policy owner_update on ai_plans for update using(auth.uid()=user_id) with check(auth.uid()=user_id); create policy owner_delete on ai_plans for delete using(auth.uid()=user_id);
create policy owner_select on notification_preferences for select using(auth.uid()=user_id); create policy owner_insert on notification_preferences for insert with check(auth.uid()=user_id); create policy owner_update on notification_preferences for update using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy owner_select on user_settings for select using(auth.uid()=user_id); create policy owner_insert on user_settings for insert with check(auth.uid()=user_id); create policy owner_update on user_settings for update using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy reference_read on exercise_library for select to authenticated using(true); create policy reference_read on food_items for select to authenticated using(true);
create policy admin_read on admin_roles for select using(auth.uid()=user_id);

insert into exercise_library(name,muscle_group,equipment,difficulty,instructions,safety_notes) values
('Bodyweight Squat','Legs','None','Beginner','Stand with feet shoulder-width apart, sit hips back and bend knees, then stand tall.','Keep knees tracking over toes.'),
('Push-up','Chest','None','Beginner','Start in a plank, lower your chest with control, then press back up.','Use an elevated surface if needed.'),
('Glute Bridge','Glutes','None','Beginner','Lie on your back, bend knees and lift hips until your body forms a line.','Avoid overextending the lower back.'),
('Reverse Lunge','Legs','None','Beginner','Step one foot back, lower under control, then return to standing.','Hold support if balance is limited.'),
('Plank','Core','None','Beginner','Brace your core and hold a straight line from shoulders to heels.','Stop if you feel sharp pain.'),
('Dumbbell Row','Back','Dumbbells','Intermediate','Hinge at the hips and pull the dumbbell toward your ribs.','Keep your back neutral.'),
('Dumbbell Shoulder Press','Shoulders','Dumbbells','Intermediate','Press dumbbells overhead from shoulder height, then lower slowly.','Use a comfortable load and controlled range.'),
('Goblet Squat','Legs','Dumbbell','Intermediate','Hold one dumbbell at the chest and squat with a stable torso.','Choose a manageable load.'),
('Jumping Jack','Full Body','None','Beginner','Jump feet out while raising arms, then return to the starting stance.','Use a low-impact step version if needed.'),
('Mountain Climber','Core','None','Intermediate','From a plank, alternate driving knees toward the chest.','Keep shoulders stacked over hands.')
on conflict(name) do nothing;
insert into food_items(name,serving_size,calories,protein,carbohydrates,fats) values
('Cooked white rice','100 g',130,2.7,28,0.3),('Oats','40 g',152,5.1,27,2.8),('Egg','1 large',72,6.3,0.4,4.8),('Chicken breast','100 g cooked',165,31,0,3.6),('Banana','1 medium',105,1.3,27,0.4),('Curd / yogurt','100 g',61,3.5,4.7,3.3),('Lentils','100 g cooked',116,9,20,0.4),('Paneer','100 g',265,18,6,20.8),('Apple','1 medium',95,0.5,25,0.3),('Almonds','30 g',174,6.4,6.1,15) on conflict(name) do nothing;

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(user_id,username,name) values(new.id, coalesce(new.raw_user_meta_data->>'username','user_'||substr(new.id::text,1,8)), coalesce(new.raw_user_meta_data->>'name','')) on conflict(user_id) do nothing;
 insert into public.notification_preferences(user_id) values(new.id) on conflict(user_id) do nothing;
 insert into public.user_settings(user_id) values(new.id) on conflict(user_id) do nothing;
 return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
