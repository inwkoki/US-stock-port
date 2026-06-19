-- =====================================================================
-- US Stock Advisor — Supabase setup (username + PIN auth, portfolio sync)
-- Run this ONCE in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.
-- PINs are bcrypt-hashed server-side. Tables are locked; only the RPC
-- functions below are callable with the public (anon) key.
-- =====================================================================

-- 1) Hashing extension
create extension if not exists pgcrypto;

-- 2) Tables
create table if not exists public.app_users (
  id         uuid primary key default gen_random_uuid(),
  username   text unique not null,
  pin_hash   text not null,
  created_at timestamptz default now()
);

create table if not exists public.portfolios (
  user_id    uuid primary key references public.app_users(id) on delete cascade,
  data       jsonb not null default '[]'::jsonb,
  updated_at timestamptz default now()
);

-- 3) Lock the tables: enable RLS with NO policies => no direct access via anon key.
alter table public.app_users  enable row level security;
alter table public.portfolios enable row level security;
revoke all on public.app_users  from anon, authenticated;
revoke all on public.portfolios from anon, authenticated;

-- 4) Server-side functions (SECURITY DEFINER => run with owner rights, bypass RLS).
create or replace function public.register(p_username text, p_pin text)
returns text language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if length(trim(p_username)) < 3 then raise exception 'Username must be at least 3 characters'; end if;
  if length(p_pin) < 4 then raise exception 'PIN must be at least 4 digits'; end if;
  if exists (select 1 from app_users where username = lower(trim(p_username))) then
    raise exception 'Username already taken';
  end if;
  insert into app_users(username, pin_hash)
    values (lower(trim(p_username)), crypt(p_pin, gen_salt('bf', 10)))
    returning id into v_id;
  insert into portfolios(user_id, data) values (v_id, '[]'::jsonb);
  return v_id::text;
end; $$;

create or replace function public.login(p_username text, p_pin text)
returns text language plpgsql security definer set search_path = public as $$
declare v app_users;
begin
  select * into v from app_users where username = lower(trim(p_username));
  if v.id is null or v.pin_hash <> crypt(p_pin, v.pin_hash) then
    raise exception 'Invalid username or PIN';
  end if;
  return v.id::text;
end; $$;

create or replace function public.load_portfolio(p_username text, p_pin text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v app_users;
begin
  select * into v from app_users where username = lower(trim(p_username));
  if v.id is null or v.pin_hash <> crypt(p_pin, v.pin_hash) then
    raise exception 'Invalid username or PIN';
  end if;
  return coalesce((select data from portfolios where user_id = v.id), '[]'::jsonb);
end; $$;

create or replace function public.save_portfolio(p_username text, p_pin text, p_data jsonb)
returns void language plpgsql security definer set search_path = public as $$
declare v app_users;
begin
  select * into v from app_users where username = lower(trim(p_username));
  if v.id is null or v.pin_hash <> crypt(p_pin, v.pin_hash) then
    raise exception 'Invalid username or PIN';
  end if;
  insert into portfolios(user_id, data, updated_at) values (v.id, p_data, now())
  on conflict (user_id) do update set data = excluded.data, updated_at = now();
end; $$;

-- 5) Expose ONLY these functions to the public key.
grant execute on function public.register(text,text)            to anon, authenticated;
grant execute on function public.login(text,text)               to anon, authenticated;
grant execute on function public.load_portfolio(text,text)      to anon, authenticated;
grant execute on function public.save_portfolio(text,text,jsonb) to anon, authenticated;

-- Done. Test in SQL editor:  select public.register('demo','123456');
