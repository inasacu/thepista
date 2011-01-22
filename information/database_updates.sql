


# add self to manage any team
insert into roles_users (role_id, user_id) values (72573, 2001)
delete from roles_users where role_id = 72573 and user_id = 2001


		
	
select * 
from matches
LEFT JOIN schedules on matches.schedule_id = schedules.id
where schedules.group_id = 9
and schedules.played = true 
and schedules.archive = false
and matches.user_id = 2001
and matches.type_id = 1 
and matches.archive = false
order by schedules.starts_at DESC



SELECT distinct matches.id, matches.user_id, matches.schedule_id, matches.type_id, types.name as type_name, matches.status_at, matches.created_at, age(matches.status_at, matches.created_at)
FROM "matches" 
left join groups_users on groups_users.user_id = matches.user_id 
left join types on types.id = matches.type_id 
WHERE (groups_users.group_id in (1,7,5,9) 
and matches.status_at >= '2010-12-16 13:30:40.532217') 
and matches.status_at != matches.created_at   
and age(matches.status_at, matches.created_at) > '00:00:00'
 



