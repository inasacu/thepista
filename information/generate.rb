

ruby script/generate controller stages
ruby script/generate model stage
rake db:migrate
ruby script/generate themed stages stage --layout=application --with_will_paginate


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



insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'A', 2,'B');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'C', 2,'D');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'E', 2,'F');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'G', 2,'H');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'B', 2,'A');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'D', 2,'C');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'F', 2,'E');
insert into stages(name, cup_id, home_ranking, home_stage_name, away_ranking, away_stage_name) values ('Mundial 2010', 1, 1, 'H', 2,'G');