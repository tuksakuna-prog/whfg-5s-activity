-- IMPORTANT: BACK UP October data before running. Run MONTHLY_UPGRADE.sql first if not already run.
-- Run this ONLY once, when October is ready to archive and November has no submissions.
select public.whfg_start_next_month('2026-11');
-- This statement archives October and clears the live October submissions.
delete from public.questions;
insert into public.questions(position,text,options,correct) values (1,'"คะแนน 5ส ประจำเดือนตุลาคม 69 ทางแผนกตรวจได้เท่าไหร่"','["69.66%", "96.28%", "98.69%", "96.82%"]'::jsonb,1);
insert into public.questions(position,text,options,correct) values (2,'"วัตถุประสงค์หลักของ ส.สร้างมาตรฐาน ในหลัก 5ส คือข้อใด"','["ทำให้พื้นที่สวยเฉพาะวันตรวจ", "รักษาผลของ 3ส แรกให้ต่อเนื่อง", "ลดจำนวนผู้รับผิดชอบพื้นที่", "เปลี่ยนวิธีจัดเก็บทุกสัปดาห์"]'::jsonb,1);
insert into public.questions(position,text,options,correct) values (3,'"กิจกรรมเดือนตุลาคม 69 ของแผนก มีคนเข้าร่วมกี่คน"','["12 คน", "13 คน", "14 คน", "15 คน"]'::jsonb,0);
insert into public.questions(position,text,options,correct) values (4,'"การตรวจประเมิน 5ส ด้วยตนเอง (Self Audit) มีประโยชน์อย่างไร"','["ใช้แทนการทำความสะอาดทั้งหมด", "ช่วยค้นหาข้อบกพร่องและปรับปรุงก่อนเกิดปัญหาซ้ำ", "ทำให้ไม่ต้องมีมาตรฐานพื้นที่", "ทำเฉพาะเพื่อเพิ่มเอกสาร"]'::jsonb,1);
insert into public.questions(position,text,options,correct) values (5,'"เมื่อทำความสะอาดแล้วพบสิ่งผิดปกติ ใครปฏิบัติได้ถูกต้องและครบถ้วนที่สุด"','["ภูริทำความสะอาดขนนกแล้วเก็บไว้", "โจทำความสะอาดรถโฟล์คลิฟท์แต่ไม่ตรวจสิ่งผิดปกติ", "โอมแจ้งหัวหน้า ถ่ายภาพ และลงบันทึกสิ่งผิดปกติ", "บิวพบสิ่งผิดปกติแล้วรอวันตรวจประเมิน"]'::jsonb,2);
create table if not exists public.memory_results(id bigint generated always as identity primary key,employee text not null unique,name text not null,score integer not null check(score between 0 and 16),elapsed_seconds integer not null,submitted_at timestamptz not null default now());
alter table public.memory_results enable row level security;
revoke all on public.memory_results from anon,authenticated;
grant all on public.memory_results to service_role;
grant usage,select on sequence public.memory_results_id_seq to service_role;
insert into public.employees(name,active) values ('เติ้ล',true) on conflict(name) do update set active=true;
