select distinct scorecards.group_id, scorecards.user_id, scorecards.played
from scorecards, groups_users
where groups_users.group_id in (
select group_id
from groups_users
group by group_id
having count(*) > 46
)
and scorecards.user_id not in (1,2,3)
and scorecards.group_id = groups_users.group_id
and scorecards.played = 0
order by scorecards.user_id



select * from users where id in (
select distinct scorecards.user_id
from scorecards, groups_users
where groups_users.group_id in (
select group_id
from groups_users
group by group_id
having count(*) > 46
)
and scorecards.user_id not in (1,2,3)
and scorecards.group_id = groups_users.group_id
and scorecards.played = 0
)