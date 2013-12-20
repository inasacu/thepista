"http://localhost:8888/thepista_client"



DUPLICATE ACCOUNTS IN SCORECARD

select id, group_id, user_id, ranking, played, archive
from scorecards 
where user_id in (
	select user_id
	from scorecards
	where archive = false
	group by group_id, user_id 
	having count(*) > 1
)
order by group_id, user_id, ranking

select group_id, user_id from scorecards where archive = false and user_id is not null group by group_id, user_id having count(*) > 1;


select id, group_id, user_id from scorecards where group_id = 20 and user_id = 3102 and id = 474 and archive = false;

update scorecards set archive = true where group_id = 20 and user_id = 3102 and id = 474 ;

select id, name, email from users where id = 3102;





bullets
Unused Eager Loading detected
  Group => [:sport, :installation]
  Remove from your finder: :include => [:sport, :installation]2013-06-15 23:04:29[WARN] user: padilla
thepista.dev
Unused Eager Loading detected
  Installation => [:venue]
  Remove from your finder: :include => [:venue]


SELECT "installations".* FROM "installations" WHERE "installations"."id" = 2 LIMIT 1




[1m[35mInstallation Load (0.6ms)[0m  SELECT "installations".* FROM "installations" WHERE "installations"."id" = 2 LIMIT 1
[1m[36mVenue Load (0.6ms)[0m  [1mSELECT "venues".* FROM "venues" WHERE "venues"."id" IN (1)[0m
	
	
	@everlane.com OR maher.janajri@gmail.com OR 
	
	jalopezo@bankinter.es
	
	
	
	delete from users where id > 3159;

  delete from authentications where id > 93;
  
  