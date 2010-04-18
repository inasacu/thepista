

ruby script/generate controller escuadras
ruby script/generate model escuadra
rake db:migrate
ruby script/generate themed escuadras escuadra --layout=application --with_will_paginate


ruby script/generate nifty_scaffold equipos



delete from cups;
delete from cups_squads;
delete from games;
delete from standings;



table to remove this summer

activity_strams
activity_stream_preferences
activity_stream_total
feeds
posts
entries
topics
tournament_users
tournaments
meets
clashes
practice_attendees
practices
