
create or replace function public.whfg_start_next_month(p_next_month text)
returns void language plpgsql security definer set search_path=public as $$
declare v_old text;
begin
 if p_next_month !~ '^20[0-9]{2}-(0[1-9]|1[0-2])$' then raise exception 'Invalid month'; end if;
 select month_key into v_old from public.quiz_settings where id=1 for update;
 if p_next_month <= v_old then raise exception 'New month must be later than current month'; end if;
 insert into public.quiz_history(month_key,questions,results) values(v_old,
 coalesce((select jsonb_agg(to_jsonb(q) order by q.position) from public.questions q),'[]'::jsonb),
 coalesce((select jsonb_agg(to_jsonb(s) order by s.submitted_at) from public.submissions s),'[]'::jsonb));
 insert into public.memory_history(month_key,results) values(v_old,coalesce((select jsonb_agg(to_jsonb(m) order by m.submitted_at) from public.memory_results m),'[]'::jsonb));
 delete from public.memory_results;delete from public.submissions;
 update public.quiz_settings set month_key=p_next_month,enabled=false,deadline_at=now() where id=1;
end;$$;
revoke all on function public.whfg_start_next_month(text) from public,anon,authenticated;
grant execute on function public.whfg_start_next_month(text) to service_role;
