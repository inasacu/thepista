
select game_number, schedule_id, name, initial_mean, initial_deviation, final_mean, final_deviation,  group_id, invite_id, group_score, invite_score
from matches
where schedule_id in (select id from schedules where played = true and group_id = 9)
and type_id = 1
and user_id = 2001
order by game_number, group_id desc, user_id


select name, schedule_id, user_id, group_id, invite_id, group_score, invite_score, mean_skill, skill_deviation, game_number
from matches
where mean_skill > 0
order by user_id, schedule_id




select matches.id, matches.schedule_id, matches.user_id, matches.group_id, matches.invite_id, matches.group_score, matches.invite_score, 
       matches.initial_mean, matches.initial_deviation, matches.game_number
from matches 
left join schedules on schedules.id = matches.schedule_id
where schedules.group_id = 9
and schedules.played = true
and matches.type_id = 1
and matches.user_id = 2001
order by schedules.starts_at , group_id desc, user_id



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
 





select matches.id, matches.schedule_id, matches.user_id, matches.group_id, matches.invite_id, matches.group_score, matches.invite_score, 
       matches.rating_average_technical, rating_average_physical,
       matches.initial_mean, matches.initial_deviation, matches.game_number, matches.type_id, matches.archive
from matches 
left join schedules on schedules.id = matches.schedule_id
where schedules.group_id = 9
and schedules.played = true
and matches.type_id = 1
order by schedule_id , group_id desc



select matches.*
from schedules, matches
where schedules.group_id = 9
and schedules.played = true
and schedules.id = matches.schedule_id
and matches.type_id = 1
order by matches.user_id, schedules.starts_at


select matches.id, matches.schedule_id, matches.user_id, matches.group_id, matches.invite_id, matches.group_score, matches.invite_score, 
       matches.rating_average_technical, rating_average_physical,
       matches.initial_mean, matches.initial_deviation, matches.game_number, matches.type_id, matches.archive
from matches 
left join schedules on schedules.id = matches.schedule_id
where schedules.group_id = 9
and schedules.played = true
and matches.type_id = 1
order by schedules.starts_at , group_id desc, user_id

