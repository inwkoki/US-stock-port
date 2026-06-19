-- Watchlist sync (run ONCE in Supabase SQL Editor, after supabase_setup.sql).
-- Stores each user's selected tickers; only reachable through the RPCs below.

create table if not exists public.watchlists (
  user_id    uuid primary key references public.app_users(id) on delete cascade,
  tickers    jsonb not null default '[]'::jsonb,
  updated_at timestamptz default now()
);
alter table public.watchlists enable row level security;
revoke all on public.watchlists from anon, authenticated;

create or replace function public.load_watchlist(p_username text, p_pin text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare v app_users;
begin
  select * into v from app_users where username = lower(trim(p_username));
  if v.id is null or v.pin_hash <> crypt(p_pin, v.pin_hash) then
    raise exception 'Invalid username or PIN';
  end if;
  return coalesce((select tickers from watchlists where user_id = v.id), '[]'::jsonb);
end; $$;

create or replace function public.save_watchlist(p_username text, p_pin text, p_tickers jsonb)
returns void language plpgsql security definer set search_path = public, extensions as $$
declare v app_users;
begin
  select * into v from app_users where username = lower(trim(p_username));
  if v.id is null or v.pin_hash <> crypt(p_pin, v.pin_hash) then
    raise exception 'Invalid username or PIN';
  end if;
  insert into watchlists(user_id, tickers, updated_at) values (v.id, p_tickers, now())
  on conflict (user_id) do update set tickers = excluded.tickers, updated_at = now();
end; $$;

grant execute on function public.load_watchlist(text,text)        to anon, authenticated;
grant execute on function public.save_watchlist(text,text,jsonb)  to anon, authenticated;
