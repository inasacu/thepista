"http://localhost:8888/thepista_client"


       (See full trace by running task with --trace)
 !
 !     Precompiling assets failed.
 !

 !     Push rejected, failed to compile Ruby app

To git@heroku.com:thepista.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@heroku.com:thepista.git'
Rauls-MacBook-Pro:thepista padilla$ heroku labs:enable user-env-compile -a thepista
Enabling user-env-compile for thepista... done
WARNING: This feature is experimental and may change or be removed without notice.
For more information see: http://devcenter.heroku.com/articles/labs-user-env-compile
Rauls-MacBook-Pro:thepista padilla$

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
	
	