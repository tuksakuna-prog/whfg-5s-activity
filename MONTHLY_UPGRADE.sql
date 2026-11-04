-- Run ONCE in Supabase SQL Editor BEFORE deploying the monthly website.
-- Does not delete existing October submissions or questions.
create table if not exists public.quiz_history (
 id bigint generated always as identity primary key,
 month_key text not null unique,
 questions jsonb not null,
 results jsonb not null,
 archived_at timestamptz not null default now()
);
alter table public.quiz_history enable row level security;
revoke all on public.quiz_history from anon, authenticated;
grant all on public.quiz_history to service_role;
grant usage, select on sequence public.quiz_history_id_seq to service_role;
insert into public.quiz_settings(id,enabled,deadline_at) values(1,false,now()) on conflict(id) do nothing;
alter table public.quiz_settings add column if not exists month_key text not null default '2026-10';
-- One atomic operation: preserve old month, clear old submissions, prepare a disabled new month.
create or replace function public.whfg_start_next_month(p_next_month text)
returns void language plpgsql security definer set search_path=public as $$
declare v_old text; v_count integer;
begin
 if p_next_month !~ '^20[0-9]{2}-(0[1-9]|1[0-2])$' then raise exception 'Invalid month'; end if;
 select month_key into v_old from public.quiz_settings where id=1 for update;
 if p_next_month <= v_old then raise exception 'New month must be later than current month'; end if;
 select count(*) into v_count from public.quiz_history where month_key=v_old;
 if v_count>0 then raise exception 'Current month already archived'; end if;
 insert into public.quiz_history(month_key,questions,results)
 values(v_old,
   coalesce((select jsonb_agg(to_jsonb(q) order by q.position) from public.questions q),'[]'::jsonb),
   coalesce((select jsonb_agg(to_jsonb(s) order by s.submitted_at) from public.submissions s),'[]'::jsonb));
 delete from public.submissions;
 update public.quiz_settings set month_key=p_next_month,enabled=false,deadline_at=now() where id=1;
end;$$;
revoke all on function public.whfg_start_next_month(text) from public,anon,authenticated;
grant execute on function public.whfg_start_next_month(text) to service_role;

-- For later months, archive game results too.
create table if not exists public.memory_history(month_key text primary key,results jsonb not null,archived_at timestamptz not null default now());
alter table public.memory_history enable row level security;
revoke all on public.memory_history from anon,authenticated;
grant all on public.memory_history to service_role;
