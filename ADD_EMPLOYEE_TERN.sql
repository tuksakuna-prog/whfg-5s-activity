-- เพิ่มพนักงาน เติ้ล โดยไม่ลบรายชื่อหรือคำตอบเดิม
insert into public.employees (name, active) values ('เติ้ล', true)
on conflict (name) do update set active = true;
