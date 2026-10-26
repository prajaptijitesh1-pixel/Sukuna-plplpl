-- Run in Supabase SQL Editor. Creates secure user profiles for the SUKUNA web panel.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null default 'user' check (role in ('user','admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name, role)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name',''), 'user')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users for each row execute procedure public.handle_new_user();

-- SECURITY DEFINER helper avoids recursive RLS when checking the admin role.
create or replace function public.is_sukuna_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;
grant execute on function public.is_sukuna_admin() to authenticated;

-- Users can see their own profile; admins can list all profiles.
drop policy if exists "read own profile or admin list" on public.profiles;
create policy "read own profile or admin list" on public.profiles
for select to authenticated using (auth.uid() = id or public.is_sukuna_admin());
drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);
-- Restrict column-level updates so a normal user cannot promote themselves to admin.
revoke update on public.profiles from authenticated;
grant update (full_name) on public.profiles to authenticated;
drop policy if exists "insert own profile" on public.profiles;
create policy "insert own profile" on public.profiles
for insert to authenticated with check (auth.uid() = id and role = 'user');

-- After registering your own account, promote it to admin from the SQL Editor:
-- update public.profiles p set role = 'admin'
-- from auth.users u where p.id = u.id and u.email = 'YOUR_EMAIL_ADDRESS';
