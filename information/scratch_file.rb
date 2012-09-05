


select * from delayed_jobs where handler  like '%recipient_id: 2908%'

update users set email='raulpadilla@haypista.com' where id = 2908


delete from delayed_jobs where handler not like '%recipient_id: 2908%'


update schedules set send_created_at = null



