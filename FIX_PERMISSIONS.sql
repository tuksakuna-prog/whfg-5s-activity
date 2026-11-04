-- Run once in Supabase SQL Editor as postgres. Does not grant access to anon/authenticated.
GRANT USAGE ON SCHEMA public TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
 public.quiz_settings, public.questions, public.submissions, public.employees
 TO service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
-- Verify:
SELECT table_name, has_table_privilege('service_role', format('public.%I',table_name), 'SELECT') AS can_read
FROM information_schema.tables
WHERE table_schema='public' AND table_name IN ('quiz_settings','questions','submissions','employees');
