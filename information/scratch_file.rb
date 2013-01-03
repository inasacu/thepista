
# set app offline
$ heroku maintenance:on --app zurb
Maintenance mode enabled.

# restore database
heroku pgbackups:restore HEROKU_POSTGRESQL_JADE b030 --app zurb

# set app online
$ heroku maintenance:off --app zurb
Maintenance mode disabled.








<script type="text/javascript">
    var disqus_shortname = 'jtwang';

    var disqus_identifier = 'http://johntwang.com/blog/2011/09/13/remove-heroku-toolkit';
    var disqus_url = 'http://johntwang.com/blog/2011/09/13/remove-heroku-toolkit/';
	var disqus_title = 'Remove the Heroku Toolbelt';
	
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://jtwang.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>

<script type="text/javascript">

	var disqus_shortname = 'haypista'; 
	var disqus_title = ' HayPista - TEAMName Jornada 9'; 
	var disqus_developer = 0; 
	var disqus_identifier = 'http://haypista.com/schedules/ac_la_maso_jornada_9';
	var disqus_url = 'http://haypista.com/schedules/ac_la_maso_jornada_9';				
	var disqus_category_id = '1410371';

	var disqus_config = function () { this.language = "es_ES"; };


	/* * * DON'T EDIT BELOW THIS LINE * * */
	(function() {
		var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
		dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
		(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
		})();

</script>




<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf8">
    <title> Heroku | Page Not Found</title>


    <meta name="viewport" content="width=device-width">

    <link href="//s3.amazonaws.com/heroku-help/error-pages/images/favicon.ico" rel="icon" type="image/ico" />
    <link href="//s3.amazonaws.com/heroku-help/error-pages/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="//use.typekit.net/lpc2yow.js"></script>
    <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
  </head>

  <body>
    <div class="error-404 l-wrapper">
      <h2>The page you were looking for does not exist.</h2>

      <p>
        You may have mistyped the address<br>
        or the page has moved.
      </p>
    </div>
  </body>
</html>




________________________________________________________________________________________________________________________________________________________________


<link rel="stylesheet" href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css" />
<script>
$(function() {
    // $( "#datepicker" ).datepicker();


$( "#datepicker" ).datepicker({
				
			
			// defaultDate: <%= "+#{Time.zone.now + @schedule.starts_at}" %>,
			firstDay: 1,
			// gotoCurrent: true,
            showOtherMonths: true,
            selectOtherMonths: true,
			dayNamesMin: ["<%= t('sunday_short') %>", "<%= t('monday_short') %>", "<%= t('tuesday_short') %>", "<%= t('wednesday_short') %>", 
						   "<%= t('thursday_short') %>", "<%= t('friday_short') %>", "<%= t('saturday_short') %>" ],
						
			// monthNames: ["<%= t('january') %>", "<%= t('february') %>", "<%= t('march') %>", "<%= t('april') %>", 
			// 			 "<%= t('may') %>", "<%= t('june') %>", "<%= t('july') %>", "<%= t('august') %>",
			// 			 "<%= t('september') %>", "<%= t('october') %>", "<%= t('november') %>", "<%= t('december') %>"],
					            showOn: "button",
            buttonImage: "/assets/icons/schedule.png",
            buttonImageOnly: true,
			dateFormat: "dd-mm-yy",
			navigationAsDateFormat: true,
			nextText: "Later" 
			 // numberOfMonths: [ 1, 2 ]


        });

$(  "#datepicker"  ).datepicker( $.datepicker.regional[ "<%= I18n.locale %>" ] );

});
</script>

----------------------
upgrade to rails 3.2.10


Last login: Mon Dec 31 16:25:23 on ttys000
Rauls-MacBook-Pro:thepista padilla$ heroku_import
Loaded Taps v0.3.24
Auto-detected local database: postgres://postgres:72dae4@127.0.0.1/desarrollo_thepista?encoding=utf8
Warning: Data in the database 'postgres://postgres:72dae4@127.0.0.1/desarrollo_thepista?encoding=utf8' will be overwritten and will not be recoverable.
Receiving schema
Schema:          0% |                                          | ETA:  --:--:--
Schema:          2% |                                          | ETA:  00:01:39
Schema:          4% |=                                         | ETA:  00:01:23
Schema:          7% |==                                        | ETA:  00:01:20
Schema:          9% |===                                       | ETA:  00:01:15
Schema:         12% |=====                                     | ETA:  00:01:12
Schema:         14% |=====                                     | ETA:  00:01:14
Schema:         17% |=======                                   | ETA:  00:01:10
Schema:         19% |=======                                   | ETA:  00:01:06
Schema:         21% |========                                  | ETA:  00:01:03
Schema:         24% |==========                                | ETA:  00:01:00
Schema:         26% |==========                                | ETA:  00:00:57
Schema:         29% |============                              | ETA:  00:00:56
Schema:         31% |=============                             | ETA:  00:00:53
Schema:         34% |==============                            | ETA:  00:00:51
Schema:         36% |===============                           | ETA:  00:00:49
Schema:         39% |================                          | ETA:  00:00:48
Schema:         41% |=================                         | ETA:  00:00:46
Schema:         43% |==================                        | ETA:  00:00:44
Schema:         46% |===================                       | ETA:  00:00:41
Schema:         48% |====================                      | ETA:  00:00:39
Schema:         51% |=====================                     | ETA:  00:00:37
Schema:         53% |======================                    | ETA:  00:00:36
Schema:         56% |=======================                   | ETA:  00:00:34
Schema:         58% |========================                  | ETA:  00:00:33
Schema:         60% |=========================                 | ETA:  00:00:31
Schema:         63% |==========================                | ETA:  00:00:30
Schema:         65% |===========================               | ETA:  00:00:28
Schema:         68% |============================              | ETA:  00:00:26
Schema:         70% |=============================             | ETA:  00:00:24
Schema:         73% |==============================            | ETA:  00:00:22
Schema:         75% |===============================           | ETA:  00:00:20
Schema:         78% |================================          | ETA:  00:00:18
Schema:         80% |=================================         | ETA:  00:00:16
Schema:         82% |==================================        | ETA:  00:00:14
Schema:         85% |===================================       | ETA:  00:00:12
Schema:         87% |====================================      | ETA:  00:00:10
Schema:         90% |=====================================     | ETA:  00:00:08
Schema:         92% |======================================    | ETA:  00:00:06
Schema:         95% |=======================================   | ETA:  00:00:03
Schema:         97% |========================================  | ETA:  00:00:01
Schema:        100% |==========================================| Time: 00:01:23
Receiving indexes
cups:            0% |                                          | ETA:  --:--:--
cups:           50% |=====================                     | ETA:  00:00:00
cups:          100% |==========================================| Time: 00:00:01
casts:           0% |                                          | ETA:  --:--:--
casts:          25% |==========                                | ETA:  00:00:01
casts:          50% |=====================                     | ETA:  00:00:01
casts:          75% |===============================           | ETA:  00:00:00
casts:         100% |==========================================| Time: 00:00:02
challenges:      0% |                                          | ETA:  --:--:--
challenges:     50% |=====================                     | ETA:  00:00:00
challenges:    100% |==========================================| Time: 00:00:01
challenges_us:   0% |                                          | ETA:  --:--:--
challenges_us:  50% |=====================                     | ETA:  00:00:00
challenges_us: 100% |==========================================| Time: 00:00:01
cups_escuadra:   0% |                                          | ETA:  --:--:--
cups_escuadra:  50% |=====================                     | ETA:  00:00:00
cups_escuadra: 100% |==========================================| Time: 00:00:01
fees:            0% |                                          | ETA:  --:--:--
fees:           16% |======                                    | ETA:  00:00:03
fees:           33% |=============                             | ETA:  00:00:02
fees:           50% |=====================                     | ETA:  00:00:01
fees:           66% |===========================               | ETA:  00:00:01
fees:           83% |==================================        | ETA:  00:00:00
fees:          100% |==========================================| Time: 00:00:03
games:           0% |                                          | ETA:  --:--:--
games:          16% |======                                    | ETA:  00:00:02
games:          33% |=============                             | ETA:  00:00:02
games:          50% |=====================                     | ETA:  00:00:01
games:          66% |===========================               | ETA:  00:00:01
games:          83% |==================================        | ETA:  00:00:00
games:         100% |==========================================| Time: 00:00:03
groups:          0% |                                          | ETA:  --:--:--
groups:         33% |=============                             | ETA:  00:00:01
groups:         66% |===========================               | ETA:  00:00:00
groups:        100% |==========================================| Time: 00:00:01
groups_marker:   0% |                                          | ETA:  --:--:--
groups_marker:  50% |=====================                     | ETA:  00:00:00
groups_marker: 100% |==========================================| Time: 00:00:01
groups_roles:    0% |                                          | ETA:  --:--:--
groups_roles:   50% |=====================                     | ETA:  00:00:00
groups_roles:  100% |==========================================| Time: 00:00:01
groups_users:    0% |                                          | ETA:  --:--:--
groups_users:   50% |=====================                     | ETA:  00:00:00
groups_users:  100% |==========================================| Time: 00:00:01
holidays:        0% |                                          | ETA:  --:--:--
holidays:       50% |=====================                     | ETA:  00:00:00
holidays:      100% |==========================================| Time: 00:00:01
installations:   0% |                                          | ETA:  --:--:--
installations:  25% |==========                                | ETA:  00:00:02
installations:  50% |=====================                     | ETA:  00:00:02
installations:  75% |===============================           | ETA:  00:00:01
installations: 100% |==========================================| Time: 00:00:03
invitations:     0% |                                          | ETA:  --:--:--
invitations:    50% |=====================                     | ETA:  00:00:00
invitations:   100% |==========================================| Time: 00:00:01
markers:         0% |                                          | ETA:  --:--:--
markers:        50% |=====================                     | ETA:  00:00:00
markers:       100% |==========================================| Time: 00:00:01
matches:         0% |                                          | ETA:  --:--:--
matches:        20% |========                                  | ETA:  00:00:02
matches:        40% |================                          | ETA:  00:00:01
matches:        60% |=========================                 | ETA:  00:00:01
matches:        80% |=================================         | ETA:  00:00:00
matches:       100% |==========================================| Time: 00:00:03
messages:        0% |                                          | ETA:  --:--:--
messages:       12% |=====                                     | ETA:  00:00:04
messages:       25% |==========                                | ETA:  00:00:04
messages:       37% |===============                           | ETA:  00:00:03
messages:       50% |=====================                     | ETA:  00:00:02
messages:       62% |==========================                | ETA:  00:00:02
messages:       75% |===============================           | ETA:  00:00:01
messages:       87% |====================================      | ETA:  00:00:00
messages:      100% |==========================================| Time: 00:00:05
escuadras:       0% |                                          | ETA:  --:--:--
escuadras:      50% |=====================                     | ETA:  00:00:00
escuadras:     100% |==========================================| Time: 00:00:01
payments:        0% |                                          | ETA:  --:--:--
payments:       16% |======                                    | ETA:  00:00:03
payments:       33% |=============                             | ETA:  00:00:02
payments:       50% |=====================                     | ETA:  00:00:01
payments:       66% |===========================               | ETA:  00:00:01
payments:       83% |==================================        | ETA:  00:00:00
payments:      100% |==========================================| Time: 00:00:03
reservations:    0% |                                          | ETA:  --:--:--
reservations:   25% |==========                                | ETA:  00:00:01
reservations:   50% |=====================                     | ETA:  00:00:01
reservations:   75% |===============================           | ETA:  00:00:00
reservations:  100% |==========================================| Time: 00:00:02
roles:           0% |                                          | ETA:  --:--:--
roles:          50% |=====================                     | ETA:  00:00:00
roles:         100% |==========================================| Time: 00:00:01
roles_users:     0% |                                          | ETA:  --:--:--
roles_users:    33% |=============                             | ETA:  00:00:01
roles_users:    66% |===========================               | ETA:  00:00:00
roles_users:   100% |==========================================| Time: 00:00:01
schedules:       0% |                                          | ETA:  --:--:--
schedules:      25% |==========                                | ETA:  00:00:01
schedules:      50% |=====================                     | ETA:  00:00:01
schedules:      75% |===============================           | ETA:  00:00:00
schedules:     100% |==========================================| Time: 00:00:02
schema_migrat:   0% |                                          | ETA:  --:--:--
schema_migrat: 100% |==========================================| Time: 00:00:00
scorecards:      0% |                                          | ETA:  --:--:--
scorecards:     50% |=====================                     | ETA:  00:00:00
scorecards:    100% |==========================================| Time: 00:00:01
users:           0% |                                          | ETA:  --:--:--
users:          14% |=====                                     | ETA:  00:00:03
users:          28% |===========                               | ETA:  00:00:03
users:          42% |=================                         | ETA:  00:00:02
users:          57% |=======================                   | ETA:  00:00:01
users:          71% |=============================             | ETA:  00:00:01
users:          85% |===================================       | ETA:  00:00:00
users:         100% |==========================================| Time: 00:00:05
venues:          0% |                                          | ETA:  --:--:--
venues:         50% |=====================                     | ETA:  00:00:00
venues:        100% |==========================================| Time: 00:00:01
sessions:        0% |                                          | ETA:  --:--:--
sessions:       50% |=====================                     | ETA:  00:00:00
sessions:      100% |==========================================| Time: 00:00:01
standings:       0% |                                          | ETA:  --:--:--
standings:      33% |=============                             | ETA:  00:00:01
standings:      66% |===========================               | ETA:  00:00:00
standings:     100% |==========================================| Time: 00:00:01
teammates:       0% |                                          | ETA:  --:--:--
teammates:      20% |========                                  | ETA:  00:00:02
teammates:      40% |================                          | ETA:  00:00:01
teammates:      60% |=========================                 | ETA:  00:00:01
teammates:      80% |=================================         | ETA:  00:00:00
teammates:     100% |==========================================| Time: 00:00:02
timetables:      0% |                                          | ETA:  --:--:--
timetables:     50% |=====================                     | ETA:  00:00:00
timetables:    100% |==========================================| Time: 00:00:01
types:           0% |                                          | ETA:  --:--:--
types:         100% |==========================================| Time: 00:00:00
Receiving data
41 tables, 8,200 records
cups:          100% |==========================================| Time: 00:00:00
announcements: 100% |==========================================| Time: 00:00:01
authenticatio: 100% |==========================================| Time: 00:00:01
casts:         100% |==========================================| Time: 00:00:00
challenges:    100% |==========================================| Time: 00:00:00
challenges_us: 100% |==========================================| Time: 00:00:00
cities:        100% |==========================================| Time: 00:00:03
conversations: 100% |==========================================| Time: 00:00:01
cups_escuadra: 100% |==========================================| Time: 00:00:00
delayed_jobs:  100% |==========================================| Time: 00:00:00
fees:          100% |==========================================| Time: 00:00:00
games:         100% |==========================================| Time: 00:00:00
groups:        100% |==========================================| Time: 00:00:01
groups_marker: 100% |==========================================| Time: 00:00:01
groups_roles:  100% |==========================================| Time: 00:00:00
groups_users:  100% |==========================================| Time: 00:00:01
holidays:      100% |==========================================| Time: 00:00:00
installations: 100% |==========================================| Time: 00:00:01
invitations:   100% |==========================================| Time: 00:00:02
markers:       100% |==========================================| Time: 00:00:02
matches:       100% |==========================================| Time: 00:00:03
messages:      100% |==========================================| Time: 00:00:01
escuadras:     100% |==========================================| Time: 00:00:01
open_id_authe: 100% |==========================================| Time: 00:00:00
open_id_authe: 100% |==========================================| Time: 00:00:01
payments:      100% |==========================================| Time: 00:00:00
reservations:  100% |==========================================| Time: 00:00:01
roles:         100% |==========================================| Time: 00:00:01
roles_users:   100% |==========================================| Time: 00:00:01
schedules:     100% |==========================================| Time: 00:00:01
schema_migrat: 100% |==========================================| Time: 00:00:01
scorecards:    100% |==========================================| Time: 00:00:01
sports:        100% |==========================================| Time: 00:00:03
users:         100% |==========================================| Time: 00:00:03
venues:        100% |==========================================| Time: 00:00:01
sessions:      100% |==========================================| Time: 00:00:00
standings:     100% |==========================================| Time: 00:00:00
states:        100% |==========================================| Time: 00:00:01
teammates:     100% |==========================================| Time: 00:00:01
timetables:    100% |==========================================| Time: 00:00:02
types:         100% |==========================================| Time: 00:00:01
Resetting sequences

Rauls-MacBook-Pro:thepista padilla$ cls
g
Rauls-MacBook-Pro:thepista padilla$ gst
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   app/views/users/_sidebar_zurb.html.erb
#
no changes added to commit (use "git add" and/or "git commit -a")
Rauls-MacBook-Pro:thepista padilla$ gadd
Rauls-MacBook-Pro:thepista padilla$ gcm "clean up challenges sidebar for user profile..."
[master 6982ee3] clean up challenges sidebar for user profile...
 1 files changed, 3 insertions(+), 6 deletions(-)
Rauls-MacBook-Pro:thepista padilla$ git push zurb master
Counting objects: 11, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 524 bytes, done.
Total 6 (delta 5), reused 0 (delta 0)
-----> Removing .DS_Store files
-----> Ruby/Rails app detected
-----> Installing dependencies using Bundler version 1.3.0.pre.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
       Using rake (0.9.2.2)
       Using acl9 (0.12.0)
       Using i18n (0.6.0)
       Using multi_json (1.3.6)
       Using activesupport (3.2.1)
       Using builder (3.0.0)
       Using activemodel (3.2.1)
       Using erubis (2.7.0)
       Using journey (1.0.4)
       Using rack (1.4.1)
       Using rack-cache (1.2)
       Using rack-test (0.6.1)
       Using hike (1.2.1)
       Using tilt (1.3.3)
       Using sprockets (2.1.3)
       Using actionpack (3.2.1)
       Using mime-types (1.19)
       Using polyglot (0.3.3)
       Using treetop (1.4.10)
       Using mail (2.4.4)
       Using actionmailer (3.2.1)
       Using arel (3.0.2)
       Using tzinfo (0.3.33)
       Using activerecord (3.2.1)
       Using activeresource (3.2.1)
       Using acts_as_commentable (3.0.1)
       Using acts_as_tree (0.1.1)
       Using agent_orange (0.1.3)
       Using authlogic (3.1.3)
       Using authlogic-oid (1.0.4)
       Using multi_xml (0.5.1)
       Using httparty (0.8.3)
       Using json (1.7.4)
       Using nokogiri (1.5.5)
       Using uuidtools (2.1.3)
       Using aws-sdk (1.5.8)
       Using cocaine (0.2.1)
       Using coffee-script-source (1.3.3)
       Using execjs (1.4.0)
       Using coffee-script (2.2.0)
       Using rack-ssl (1.3.2)
       Using rdoc (3.12)
       Using thor (0.14.6)
       Using railties (3.2.1)
       Using coffee-rails (3.2.2)
       Using composite_primary_keys (5.0.8)
       Using daemons (1.1.8)
       Using delayed_job (3.0.3)
       Using delayed_job_active_record (0.3.2)
       Using eventmachine (0.12.10)
       Using multipart-post (1.1.5)
       Using faraday (0.8.4)
       Using ffi (1.1.1)
       Using friendly_id (4.0.7)
       Using geokit (1.6.5)
       Using geokit-rails (1.1.4)
       Using google_map (0.0.4)
       Using hashie (1.2.0)
       Using hirefireapp (0.0.8)
       Using hoptoad_notifier (2.4.11)
       Using httpauth (0.1)
       Using jquery-rails (2.0.2)
       Using json_pure (1.7.4)
       Using jwt (0.1.5)
       Using oauth (0.4.7)
       Using oauth2 (0.8.0)
       Using omniauth (1.1.1)
       Using omniauth-browserid (0.0.1)
       Using omniauth-oauth2 (1.1.1)
       Using omniauth-facebook (1.4.1)
       Using omniauth-oauth (1.0.1)
       Using omniauth-google (1.0.2)
       Using omniauth-linkedin (0.0.8)
       Using omniauth-twitter (0.0.13)
       Using paperclip (3.1.4)
       Using pg (0.14.0)
       Using bundler (1.3.0.pre.2)
       Using rails (3.2.1)
       Using recaptcha (0.3.4)
       Using rpx_now (0.6.24)
       Using sass (3.1.20)
       Using sass-rails (3.2.5)
       Using sitemap_generator (3.1.1)
       Using texticle (2.0.3)
       Using thin (1.4.1)
       Using typhoeus (0.4.2)
       Using uglifier (1.2.6)
       Using will_paginate (3.0.3)
       Using zurb-foundation (2.2.1.2)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Writing config/database.yml to read from DATABASE_URL
-----> Preparing app for Rails asset pipeline
       Running: rake assets:precompile
       rake aborted!
       could not connect to server: Connection refused
       Is the server running on host "127.0.0.1" and accepting
       TCP/IP connections on port 5432?
       Tasks: TOP => environment
       (See full trace by running task with --trace)
       Precompiling assets failed, enabling runtime asset compilation
       Injecting rails31_enable_runtime_asset_compilation
       Please see this article for troubleshooting help:
       http://devcenter.heroku.com/articles/rails31_heroku_cedar#troubleshooting
-----> Rails plugin injection
       Injecting rails_log_stdout
       Injecting rails3_serve_static_assets
-----> Discovering process types
       Procfile declares types      -> web, worker
       Default types for Ruby/Rails -> console, rake
-----> Compiled slug size: 41.4MB
-----> Launching... done, v174
       http://zurb.herokuapp.com deployed to Heroku

To git@heroku.com:zurb.git
   1f87e14..6982ee3  master -> master
Rauls-MacBook-Pro:thepista padilla$ git push staging master
Counting objects: 11, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 524 bytes, done.
Total 6 (delta 5), reused 0 (delta 0)
-----> Removing .DS_Store files
-----> Ruby/Rails app detected
-----> Installing dependencies using Bundler version 1.3.0.pre.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
       Using rake (0.9.2.2)
       Using acl9 (0.12.0)
       Using i18n (0.6.0)
       Using multi_json (1.3.6)
       Using activesupport (3.2.1)
       Using builder (3.0.0)
       Using activemodel (3.2.1)
       Using erubis (2.7.0)
       Using journey (1.0.4)
       Using rack (1.4.1)
       Using rack-cache (1.2)
       Using rack-test (0.6.1)
       Using hike (1.2.1)
       Using tilt (1.3.3)
       Using sprockets (2.1.3)
       Using actionpack (3.2.1)
       Using mime-types (1.19)
       Using polyglot (0.3.3)
       Using treetop (1.4.10)
       Using mail (2.4.4)
       Using actionmailer (3.2.1)
       Using arel (3.0.2)
       Using tzinfo (0.3.33)
       Using activerecord (3.2.1)
       Using activeresource (3.2.1)
       Using acts_as_commentable (3.0.1)
       Using acts_as_tree (0.1.1)
       Using agent_orange (0.1.3)
       Using authlogic (3.1.3)
       Using authlogic-oid (1.0.4)
       Using multi_xml (0.5.1)
       Using httparty (0.8.3)
       Using json (1.7.4)
       Using nokogiri (1.5.5)
       Using uuidtools (2.1.3)
       Using aws-sdk (1.5.8)
       Using cocaine (0.2.1)
       Using coffee-script-source (1.3.3)
       Using execjs (1.4.0)
       Using coffee-script (2.2.0)
       Using rack-ssl (1.3.2)
       Using rdoc (3.12)
       Using thor (0.14.6)
       Using railties (3.2.1)
       Using coffee-rails (3.2.2)
       Using composite_primary_keys (5.0.8)
       Using daemons (1.1.8)
       Using delayed_job (3.0.3)
       Using delayed_job_active_record (0.3.2)
       Using eventmachine (0.12.10)
       Using multipart-post (1.1.5)
       Using faraday (0.8.4)
       Using ffi (1.1.1)
       Using friendly_id (4.0.7)
       Using geokit (1.6.5)
       Using geokit-rails (1.1.4)
       Using google_map (0.0.4)
       Using hashie (1.2.0)
       Using hirefireapp (0.0.8)
       Using hoptoad_notifier (2.4.11)
       Using httpauth (0.1)
       Using jquery-rails (2.0.2)
       Using json_pure (1.7.4)
       Using jwt (0.1.5)
       Using oauth (0.4.7)
       Using oauth2 (0.8.0)
       Using omniauth (1.1.1)
       Using omniauth-browserid (0.0.1)
       Using omniauth-oauth2 (1.1.1)
       Using omniauth-facebook (1.4.1)
       Using omniauth-oauth (1.0.1)
       Using omniauth-google (1.0.2)
       Using omniauth-linkedin (0.0.8)
       Using omniauth-twitter (0.0.13)
       Using paperclip (3.1.4)
       Using pg (0.14.0)
       Using bundler (1.3.0.pre.2)
       Using rails (3.2.1)
       Using recaptcha (0.3.4)
       Using rpx_now (0.6.24)
       Using sass (3.1.20)
       Using sass-rails (3.2.5)
       Using sitemap_generator (3.1.1)
       Using texticle (2.0.3)
       Using thin (1.4.1)
       Using typhoeus (0.4.2)
       Using uglifier (1.2.6)
       Using will_paginate (3.0.3)
       Using zurb-foundation (2.2.1.2)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Writing config/database.yml to read from DATABASE_URL
-----> Preparing app for Rails asset pipeline
       Running: rake assets:precompile
       rake aborted!
       could not connect to server: Connection refused
       Is the server running on host "127.0.0.1" and accepting
       TCP/IP connections on port 5432?
       Tasks: TOP => environment
       (See full trace by running task with --trace)
       Precompiling assets failed, enabling runtime asset compilation
       Injecting rails31_enable_runtime_asset_compilation
       Please see this article for troubleshooting help:
       http://devcenter.heroku.com/articles/rails31_heroku_cedar#troubleshooting
-----> Rails plugin injection
       Injecting rails_log_stdout
       Injecting rails3_serve_static_assets
-----> Discovering process types
       Procfile declares types      -> web, worker
       Default types for Ruby/Rails -> console, rake
-----> Compiled slug size: 41.4MB
-----> Launching... done, v151
       http://thepista.herokuapp.com deployed to Heroku

To git@heroku.com:thepista.git
   1f87e14..6982ee3  master -> master
Rauls-MacBook-Pro:thepista padilla$ 
Last login: Tue Jan  1 22:09:00 on console
Rauls-MacBook-Pro:thepista padilla$ 
Last login: Wed Jan  2 12:12:32 on console
Rauls-MacBook-Pro:thepista padilla$ cls

Rauls-MacBook-Pro:thepista padilla$ bundle update
Fetching gem metadata from https://rubygems.org/.......
Fetching gem metadata from https://rubygems.org/..
Installing rake (10.0.3) 
Using acl9 (0.12.0) 
Installing i18n (0.6.1) 
Installing multi_json (1.5.0) 
Installing activesupport (3.2.10) 
Installing builder (3.0.4) 
Installing activemodel (3.2.10) 
Using erubis (2.7.0) 
Using journey (1.0.4) 
Using rack (1.4.1) 
Using rack-cache (1.2) 
Installing rack-test (0.6.2) 
Using hike (1.2.1) 
Using tilt (1.3.3) 
Installing sprockets (2.2.2) 
Installing actionpack (3.2.10) 
Using mime-types (1.19) 
Using polyglot (0.3.3) 
Installing treetop (1.4.12) 
Using mail (2.4.4) 
Installing actionmailer (3.2.10) 
Using arel (3.0.2) 
Installing tzinfo (0.3.35) 
Installing activerecord (3.2.10) 
Installing activeresource (3.2.10) 
Installing acts_as_commentable (4.0.0) 
Using acts_as_tree (0.1.1) 
Installing agent_orange (0.1.4) 
Installing authlogic (3.2.0) 
Using authlogic-oid (1.0.4) 
Using multi_xml (0.5.1) 
Installing httparty (0.9.0) 
Installing json (1.7.6) with native extensions 
Installing nokogiri (1.5.6) with native extensions 
Using uuidtools (2.1.3) 
Installing aws-sdk (1.8.0) 
Using bundler (1.1.4) 
Installing chunky_png (1.2.6) 
Installing cocaine (0.4.2) 
Installing coffee-script-source (1.4.0) 
Using execjs (1.4.0) 
Using coffee-script (2.2.0) 
Using rack-ssl (1.3.2) 
Using rdoc (3.12) 
Installing thor (0.16.0) 
Installing railties (3.2.10) 
Using coffee-rails (3.2.2) 
Installing fssm (0.2.9) 
Installing sass (3.2.4) 
Installing compass (0.12.2) 
Installing composite_primary_keys (5.0.10) 
Installing daemons (1.1.9) 
Installing delayed_job (3.0.4) 
Installing delayed_job_active_record (0.3.3) 
Installing ffi (1.2.0) with native extensions 
Installing ethon (0.5.7) 
Installing eventmachine (1.0.0) with native extensions 
Using multipart-post (1.1.5) 
Using faraday (0.8.4) 
Installing friendly_id (4.0.9) 
Using geokit (1.6.5) 
Using geokit-rails (1.1.4) 
Using google_map (0.0.4) 
Using hashie (1.2.0) 
Using hirefireapp (0.0.8) 
Using hoptoad_notifier (2.4.11) 
Installing httpauth (0.2.0) 
Installing jquery-rails (2.1.4) 
Installing json_pure (1.7.6) 
Using jwt (0.1.5) 
Installing sassy-math (1.2) 
Installing modular-scale (1.0.3) 
Using oauth (0.4.7) 
Using oauth2 (0.8.0) 
Using omniauth (1.1.1) 
Using omniauth-browserid (0.0.1) 
Using omniauth-oauth2 (1.1.1) 
Using omniauth-facebook (1.4.1) 
Using omniauth-oauth (1.0.1) 
Using omniauth-google (1.0.2) 
Using omniauth-linkedin (0.0.8) 
Installing omniauth-twitter (0.0.14) 
Installing paperclip (3.4.0) 
Installing pg (0.14.1) with native extensions 
Installing rails (3.2.10) 
Using recaptcha (0.3.4) 
Using rpx_now (0.6.24) 
Using sass-rails (3.2.5) 
Installing sitemap_generator (3.4) 
Using texticle (2.0.3) 
Installing thin (1.5.0) with native extensions 
Installing typhoeus (0.5.3) 
Installing uglifier (1.3.0) 
Using will_paginate (3.0.3) 
Installing zurb-foundation (3.2.3) 
Your bundle is updated! Use `bundle show [gemname]` to see where a bundled gem is installed.
Rauls-MacBook-Pro:thepista padilla$ powder restart
Rauls-MacBook-Pro:thepista padilla$ powder open
Rauls-MacBook-Pro:thepista padilla$ gst
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   Gemfile
#	modified:   Gemfile.lock
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	httparty/ruby/1.9.1/bin/compass
#	httparty/ruby/1.9.1/bin/sprockets
#	httparty/ruby/1.9.1/cache/actionmailer-3.2.10.gem
#	httparty/ruby/1.9.1/cache/actionpack-3.2.10.gem
#	httparty/ruby/1.9.1/cache/activemodel-3.2.10.gem
#	httparty/ruby/1.9.1/cache/activerecord-3.2.10.gem
#	httparty/ruby/1.9.1/cache/activeresource-3.2.10.gem
#	httparty/ruby/1.9.1/cache/activesupport-3.2.10.gem
#	httparty/ruby/1.9.1/cache/acts_as_commentable-4.0.0.gem
#	httparty/ruby/1.9.1/cache/agent_orange-0.1.4.gem
#	httparty/ruby/1.9.1/cache/authlogic-3.2.0.gem
#	httparty/ruby/1.9.1/cache/aws-sdk-1.8.0.gem
#	httparty/ruby/1.9.1/cache/builder-3.0.4.gem
#	httparty/ruby/1.9.1/cache/chunky_png-1.2.6.gem
#	httparty/ruby/1.9.1/cache/cocaine-0.4.2.gem
#	httparty/ruby/1.9.1/cache/coffee-script-source-1.4.0.gem
#	httparty/ruby/1.9.1/cache/compass-0.12.2.gem
#	httparty/ruby/1.9.1/cache/composite_primary_keys-5.0.10.gem
#	httparty/ruby/1.9.1/cache/daemons-1.1.9.gem
#	httparty/ruby/1.9.1/cache/delayed_job-3.0.4.gem
#	httparty/ruby/1.9.1/cache/delayed_job_active_record-0.3.3.gem
#	httparty/ruby/1.9.1/cache/ethon-0.5.7.gem
#	httparty/ruby/1.9.1/cache/eventmachine-1.0.0.gem
#	httparty/ruby/1.9.1/cache/ffi-1.2.0.gem
#	httparty/ruby/1.9.1/cache/friendly_id-4.0.9.gem
#	httparty/ruby/1.9.1/cache/fssm-0.2.9.gem
#	httparty/ruby/1.9.1/cache/httparty-0.9.0.gem
#	httparty/ruby/1.9.1/cache/httpauth-0.2.0.gem
#	httparty/ruby/1.9.1/cache/i18n-0.6.1.gem
#	httparty/ruby/1.9.1/cache/jquery-rails-2.1.4.gem
#	httparty/ruby/1.9.1/cache/json-1.7.6.gem
#	httparty/ruby/1.9.1/cache/json_pure-1.7.6.gem
#	httparty/ruby/1.9.1/cache/modular-scale-1.0.3.gem
#	httparty/ruby/1.9.1/cache/multi_json-1.5.0.gem
#	httparty/ruby/1.9.1/cache/nokogiri-1.5.6.gem
#	httparty/ruby/1.9.1/cache/omniauth-twitter-0.0.14.gem
#	httparty/ruby/1.9.1/cache/paperclip-3.4.0.gem
#	httparty/ruby/1.9.1/cache/pg-0.14.1.gem
#	httparty/ruby/1.9.1/cache/rack-test-0.6.2.gem
#	httparty/ruby/1.9.1/cache/rails-3.2.10.gem
#	httparty/ruby/1.9.1/cache/railties-3.2.10.gem
#	httparty/ruby/1.9.1/cache/rake-10.0.3.gem
#	httparty/ruby/1.9.1/cache/sass-3.2.4.gem
#	httparty/ruby/1.9.1/cache/sassy-math-1.2.gem
#	httparty/ruby/1.9.1/cache/sitemap_generator-3.4.gem
#	httparty/ruby/1.9.1/cache/sprockets-2.2.2.gem
#	httparty/ruby/1.9.1/cache/thin-1.5.0.gem
#	httparty/ruby/1.9.1/cache/thor-0.16.0.gem
#	httparty/ruby/1.9.1/cache/treetop-1.4.12.gem
#	httparty/ruby/1.9.1/cache/typhoeus-0.5.3.gem
#	httparty/ruby/1.9.1/cache/tzinfo-0.3.35.gem
#	httparty/ruby/1.9.1/cache/uglifier-1.3.0.gem
#	httparty/ruby/1.9.1/cache/zurb-foundation-3.2.3.gem
#	httparty/ruby/1.9.1/gems/actionmailer-3.2.10/
#	httparty/ruby/1.9.1/gems/actionpack-3.2.10/
#	httparty/ruby/1.9.1/gems/activemodel-3.2.10/
#	httparty/ruby/1.9.1/gems/activerecord-3.2.10/
#	httparty/ruby/1.9.1/gems/activeresource-3.2.10/
#	httparty/ruby/1.9.1/gems/activesupport-3.2.10/
#	httparty/ruby/1.9.1/gems/acts_as_commentable-4.0.0/
#	httparty/ruby/1.9.1/gems/agent_orange-0.1.4/
#	httparty/ruby/1.9.1/gems/authlogic-3.2.0/
#	httparty/ruby/1.9.1/gems/aws-sdk-1.8.0/
#	httparty/ruby/1.9.1/gems/builder-3.0.4/
#	httparty/ruby/1.9.1/gems/chunky_png-1.2.6/
#	httparty/ruby/1.9.1/gems/cocaine-0.4.2/
#	httparty/ruby/1.9.1/gems/coffee-script-source-1.4.0/
#	httparty/ruby/1.9.1/gems/compass-0.12.2/
#	httparty/ruby/1.9.1/gems/composite_primary_keys-5.0.10/
#	httparty/ruby/1.9.1/gems/daemons-1.1.9/
#	httparty/ruby/1.9.1/gems/delayed_job-3.0.4/
#	httparty/ruby/1.9.1/gems/delayed_job_active_record-0.3.3/
#	httparty/ruby/1.9.1/gems/ethon-0.5.7/
#	httparty/ruby/1.9.1/gems/eventmachine-1.0.0/
#	httparty/ruby/1.9.1/gems/ffi-1.2.0/
#	httparty/ruby/1.9.1/gems/friendly_id-4.0.9/
#	httparty/ruby/1.9.1/gems/fssm-0.2.9/
#	httparty/ruby/1.9.1/gems/httparty-0.9.0/
#	httparty/ruby/1.9.1/gems/httpauth-0.2.0/
#	httparty/ruby/1.9.1/gems/i18n-0.6.1/
#	httparty/ruby/1.9.1/gems/jquery-rails-2.1.4/
#	httparty/ruby/1.9.1/gems/json-1.7.6/
#	httparty/ruby/1.9.1/gems/json_pure-1.7.6/
#	httparty/ruby/1.9.1/gems/modular-scale-1.0.3/
#	httparty/ruby/1.9.1/gems/multi_json-1.5.0/
#	httparty/ruby/1.9.1/gems/nokogiri-1.5.6/
#	httparty/ruby/1.9.1/gems/omniauth-twitter-0.0.14/
#	httparty/ruby/1.9.1/gems/paperclip-3.4.0/
#	httparty/ruby/1.9.1/gems/pg-0.14.1/
#	httparty/ruby/1.9.1/gems/rack-test-0.6.2/
#	httparty/ruby/1.9.1/gems/railties-3.2.10/
#	httparty/ruby/1.9.1/gems/rake-10.0.3/
#	httparty/ruby/1.9.1/gems/sass-3.2.4/
#	httparty/ruby/1.9.1/gems/sassy-math-1.2/
#	httparty/ruby/1.9.1/gems/sitemap_generator-3.4/
#	httparty/ruby/1.9.1/gems/sprockets-2.2.2/
#	httparty/ruby/1.9.1/gems/thin-1.5.0/
#	httparty/ruby/1.9.1/gems/thor-0.16.0/
#	httparty/ruby/1.9.1/gems/treetop-1.4.12/
#	httparty/ruby/1.9.1/gems/typhoeus-0.5.3/
#	httparty/ruby/1.9.1/gems/tzinfo-0.3.35/
#	httparty/ruby/1.9.1/gems/uglifier-1.3.0/
#	httparty/ruby/1.9.1/gems/zurb-foundation-3.2.3/
#	httparty/ruby/1.9.1/specifications/actionmailer-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/actionpack-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/activemodel-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/activerecord-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/activeresource-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/activesupport-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/acts_as_commentable-4.0.0.gemspec
#	httparty/ruby/1.9.1/specifications/agent_orange-0.1.4.gemspec
#	httparty/ruby/1.9.1/specifications/authlogic-3.2.0.gemspec
#	httparty/ruby/1.9.1/specifications/aws-sdk-1.8.0.gemspec
#	httparty/ruby/1.9.1/specifications/builder-3.0.4.gemspec
#	httparty/ruby/1.9.1/specifications/chunky_png-1.2.6.gemspec
#	httparty/ruby/1.9.1/specifications/cocaine-0.4.2.gemspec
#	httparty/ruby/1.9.1/specifications/coffee-script-source-1.4.0.gemspec
#	httparty/ruby/1.9.1/specifications/compass-0.12.2.gemspec
#	httparty/ruby/1.9.1/specifications/composite_primary_keys-5.0.10.gemspec
#	httparty/ruby/1.9.1/specifications/daemons-1.1.9.gemspec
#	httparty/ruby/1.9.1/specifications/delayed_job-3.0.4.gemspec
#	httparty/ruby/1.9.1/specifications/delayed_job_active_record-0.3.3.gemspec
#	httparty/ruby/1.9.1/specifications/ethon-0.5.7.gemspec
#	httparty/ruby/1.9.1/specifications/eventmachine-1.0.0.gemspec
#	httparty/ruby/1.9.1/specifications/ffi-1.2.0.gemspec
#	httparty/ruby/1.9.1/specifications/friendly_id-4.0.9.gemspec
#	httparty/ruby/1.9.1/specifications/fssm-0.2.9.gemspec
#	httparty/ruby/1.9.1/specifications/httparty-0.9.0.gemspec
#	httparty/ruby/1.9.1/specifications/httpauth-0.2.0.gemspec
#	httparty/ruby/1.9.1/specifications/i18n-0.6.1.gemspec
#	httparty/ruby/1.9.1/specifications/jquery-rails-2.1.4.gemspec
#	httparty/ruby/1.9.1/specifications/json-1.7.6.gemspec
#	httparty/ruby/1.9.1/specifications/json_pure-1.7.6.gemspec
#	httparty/ruby/1.9.1/specifications/modular-scale-1.0.3.gemspec
#	httparty/ruby/1.9.1/specifications/multi_json-1.5.0.gemspec
#	httparty/ruby/1.9.1/specifications/nokogiri-1.5.6.gemspec
#	httparty/ruby/1.9.1/specifications/omniauth-twitter-0.0.14.gemspec
#	httparty/ruby/1.9.1/specifications/paperclip-3.4.0.gemspec
#	httparty/ruby/1.9.1/specifications/pg-0.14.1.gemspec
#	httparty/ruby/1.9.1/specifications/rack-test-0.6.2.gemspec
#	httparty/ruby/1.9.1/specifications/rails-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/railties-3.2.10.gemspec
#	httparty/ruby/1.9.1/specifications/rake-10.0.3.gemspec
#	httparty/ruby/1.9.1/specifications/sass-3.2.4.gemspec
#	httparty/ruby/1.9.1/specifications/sassy-math-1.2.gemspec
#	httparty/ruby/1.9.1/specifications/sitemap_generator-3.4.gemspec
#	httparty/ruby/1.9.1/specifications/sprockets-2.2.2.gemspec
#	httparty/ruby/1.9.1/specifications/thin-1.5.0.gemspec
#	httparty/ruby/1.9.1/specifications/thor-0.16.0.gemspec
#	httparty/ruby/1.9.1/specifications/treetop-1.4.12.gemspec
#	httparty/ruby/1.9.1/specifications/typhoeus-0.5.3.gemspec
#	httparty/ruby/1.9.1/specifications/tzinfo-0.3.35.gemspec
#	httparty/ruby/1.9.1/specifications/uglifier-1.3.0.gemspec
#	httparty/ruby/1.9.1/specifications/zurb-foundation-3.2.3.gemspec
no changes added to commit (use "git add" and/or "git commit -a")
Rauls-MacBook-Pro:thepista padilla$ 





