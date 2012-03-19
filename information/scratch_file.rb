Started POST "/user_sessions" for 127.0.0.1 at 2012-03-17 20:30:06 +0100
Processing by UserSessionsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"i0JkEezjah8++gvYqkQiqVP9l3eGBywClBLndnxlcuI=", "user_session"=>{"email"=>"raulmpadilla@gmail.com", "password"=>"[FILTERED]"}, "commit"=>"Entrar"}
  [1m[36mUser Load (1.2ms)[0m  [1mSELECT "users".* FROM "users" WHERE "users"."email" = 'raulmpadilla@gmail.com' LIMIT 1[0m
  [1m[35m (0.1ms)[0m  BEGIN
  [1m[36m (0.6ms)[0m  [1mUPDATE "users" SET "login_count" = 1566, "last_login_at" = '2012-03-17 18:00:25.239989', "current_login_at" = '2012-03-17 19:30:06.435283', "last_login_ip" = '88.25.225.91', "current_login_ip" = '127.0.0.1', "last_request_at" = '2012-03-17 19:30:06.435643', "perishable_token" = 'J7qOhGqy5LTTJvWLw7D1', "updated_at" = '2012-03-17 19:30:06.437324' WHERE "users"."id" = 2001[0m
[paperclip] Saving attachments.
  [1m[35m (0.7ms)[0m  COMMIT
Redirected to http://thepista.dev/
Completed 302 Found in 12ms (ActiveRecord: 2.6ms)


Started GET "/" for 127.0.0.1 at 2012-03-17 20:30:06 +0100
Processing by HomeController#index as HTML
  [1m[36mUser Load (0.8ms)[0m  [1mSELECT "users".* FROM "users" WHERE "users"."id" = 2001 LIMIT 1[0m
  [1m[35m (0.2ms)[0m  BEGIN
  [1m[36m (0.5ms)[0m  [1mUPDATE "users" SET "last_request_at" = '2012-03-17 19:30:06.466332', "perishable_token" = 'MQ2x0RVEYf8fxZylfpe', "updated_at" = '2012-03-17 19:30:06.467107' WHERE "users"."id" = 2001[0m
[paperclip] Saving attachments.
  [1m[35m (0.7ms)[0m  COMMIT
  [1m[36mTeammate Load (1.6ms)[0m  [1mSELECT id FROM "teammates" WHERE (accepted_at >= '2012-03-14 19:27:52.220857' and status = 'accepted') ORDER BY id[0m
  [1m[35mTeammate Load (0.7ms)[0m  SELECT "teammates".* FROM "teammates" WHERE (id in (NULL)) ORDER BY accepted_at desc
  



