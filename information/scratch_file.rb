 

def table_announcements 
	message
	starts_at
	ends_at
	created_at
	updated_at
end

def table_authentications
	user_id
	provider
	uid
	created_at
	updated_at
end

def table_casts
	challenge_id
	user_id
	game_id
	home_score
	away_score
	points 
	created_at
	updated_at
	archive 
	slug
end



def table_challenges
	name
	cup_id
	starts_at
	ends_at
	reminder_at
	fee_per_game 
	time_zone
	description
	conditions
	player_limit 
	archive 
	created_at
	updated_at
	automatic_petition
	slug
	service_id 
end



def table_challenges_users 
	challenge_id
	user_id
	created_at
	updated_at
	archive 
end



def table_cities
	name
	state_id 
	archive 
	created_at
	updated_at
end

def table_conversations
	created_at
	updated_at
	archive 
end

def table_cups 
	name
	starts_at
	ends_at
	deadline_at
	time_zone
	sport_id
	group_stage 
	group_stage_single
	second_stage_single
	final_stage_single
	group_stage_advance
	points_for_win 
	points_for_draw 
	points_for_lose 
	description
	conditions
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	archive 
	created_at
	updated_at
	official 
	club 
	slug
	venue_id 
end



def table_cups_escuadras 
	cup_id
	escuadra_id
	created_at
	updated_at
	archive 
end



def table_delayed_jobs
	priority 
	attempts 
	handler
	last_error
	run_at
	locked_at
	failed_at
	locked_by
	created_at
	updated_at
	queue
end

def table_enchufados
	name
	url
	language
	venue_id
	category_id
	play_id 
	service_id
	api
	secret
	created_at 
	updated_at 
end

def table_escuadras 
	name
	description
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	archive 
	created_at
	updated_at
	item_id
	item_type
	slug
	official 
end



def table_fees
	name 
	description
	payed 
	archive 
	created_at
	updated_at
	debit_amount 
	debit_id
	debit_type
	credit_id
	credit_type
	manager_id
	item_type
	item_id
	type_id
	season_player 
	slug
end



def table_games
	name
	starts_at
	ends_at
	reminder_at
	deadline_at
	cup_id
	home_id
	away_id
	winner_id
	next_game_id
	home_ranking
	home_stage_name
	away_ranking
	away_stage_name
	home_score
	away_score
	jornada 
	round 
	played 
	type_name 
	points_for_single 
	points_for_double 
	created_at
	updated_at
	points_for_draw 
	points_for_goal_difference 
	points_for_goal_total 
	points_for_winner 
	archive 
	slug
end



def table_groups
	name
	second_team
	gameday_at
	points_for_win 
	points_for_draw 
	points_for_lose 
	time_zone 
	sport_id
	marker_id
	description
	conditions
	player_limit 
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	archive 
	created_at
	updated_at
	automatic_petition
	installation_id
	slug
	service_id 
	item_id
	item_type
end



def table_groups_markers
	group_id
	marker_id
	created_at
	updated_at
	archive 
end



def table_groups_roles 
	group_id
	role_id
	created_at
	updated_at
	archive 
end



def table_groups_users 
	group_id
	user_id
	created_at
	updated_at
	archive 
end



def table_holidays
	name
	venue_id
	starts_at
	ends_at
	holiday_hour
	archive 
	created_at
	updated_at
	type_id
end



def table_installations
	name
	venue_id
	sport_id
	marker_id
	starts_at
	ends_at
	timeframe 
	fee_per_pista 
	fee_per_lighting 
	public 
	lighting 
	outdoor 
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	description
	conditions
	archive 
	created_at
	updated_at
	slug
end



def table_invitations
	email_addresses
	message
	user_id
	archive 
	created_at
	updated_at
	item_id
	item_type
end


def table_markers
	name 
	latitude 
	longitude 
	direction
	image_url
	url
	contact 
	email
	phone 
	address 
	city 
	region 
	zip 
	surface
	facility
	starts_at
	ends_at
	time_zone 
	public 
	activation 
	description
	icon 
	shadow 
	archive 
	created_at
	updated_at
	item_id
	item_type
	lat 
	lng 
	slug
	short_name
end



def table_matches
	schedule_id
	user_id
	group_id
	invite_id 
	group_score
	invite_score
	goals_scored 
	roster_position 
	played 
	one_x_two 
	user_x_two 
	type_id
	status_at 
	archive 
	created_at
	updated_at
	rating_average_technical 
	rating_average_physical 
	initial_mean 
	initial_deviation 
	final_mean 
	final_deviation 
	game_number 
	block_token
	change_id
	changed_at
end



def table_messages
	subject 
	body
	parent_id
	sender_id
	recipient_id
	conversation_id
	reply_id
	replied_at
	sender_deleted_at
	sender_read_at
	recipient_deleted_at
	recipient_read_at
	replies 
	reviews 
	archive 
	created_at
	updated_at
	item_id
	item_type
	received_messageable_id
	received_messageable_type
	sent_messageable_id
	sent_messageable_type
	opened 
	recipient_delete 
	sender_delete 
	ancestry
	recipient_permanent_delete 
	sender_permanent_delete 
end



def table_open_id_authentication_associations
	t.integer issued
	t.integer lifetime
	t.string handle
	t.string assoc_type
	t.binary server_url
	t.binary secret
end

def table_open_id_authentication_nonces
	t.integer timestamp
	t.string server_url
	t.string salt 
end

def table_payments
	name 
	debit_amount 
	credit_amount 
	description
	archive 
	created_at
	updated_at
	debit_id
	debit_type
	credit_id
	credit_type
	manager_id
	fee_id
	item_type
	item_id
	slug
end



def table_prospects
	name
	contact
	email
	email_additional
	phone
	url
	url_additional
	letter_first
	letter_second
	response_first
	response_second
	notes
	created_at 
	updated_at 
	image
	installations
	description
	conditions
	archive 
end

def table_reservations
	name
	starts_at
	ends_at
	reminder_at
	venue_id
	installation_id
	item_id
	item_type
	fee_per_pista 
	fee_per_lighting
	available 
	reminder 
	public 
	description
	block_token
	archive 
	created_at
	updated_at
	code
	slug
end


def table_roles
	name 
	authorizable_type
	authorizable_id
	created_at
	updated_at
	archive 
end



def table_roles_users 
	user_id
	role_id
	created_at
	updated_at
	archive 
end


def table_schedules
	name
	season
	jornada
	starts_at
	ends_at
	subscription_at
	non_subscription_at
	fee_per_game 
	fee_per_pista 
	remind_before 
	repeat_every 
	time_zone 
	group_id
	sport_id
	marker_id
	player_limit 
	played 
	public 
	archive 
	created_at
	updated_at
	reminder 
	reminder_at
	send_reminder_at
	send_result_at
	send_comment_at
	slug
	send_created_at
end


def table_scorecards
	group_id
	user_id
	wins 
	draws 
	losses 
	points 
	ranking 
	played 
	assigned 
	goals_for 
	goals_against 
	goals_scored 
	previous_points 
	previous_ranking 
	previous_played 
	payed 
	archive 
	created_at
	updated_at
	season_ends_at
	field_goal_attempt
	field_goal_made 
	free_throw_attempt
	free_throw_made 
	three_point_attempt
	three_point_made 
	rebounds_defense 
	rebounds_offense 
	minutes_played 
	assists 
	steals 
	blocks 
	turnovers 
	personal_fouls 
	started 
end



def table_sessions
	session_id
	data
	created_at
	updated_at
end



def table_sports
	name 
	description
	icon 
	points_for_win 
	points_for_lose 
	points_for_draw 
	created_at
	updated_at
	player_limit 
end

def table_standings
	cup_id
	challenge_id
	item_id
	item_type
	group_stage_name
	wins 
	draws 
	losses 
	points 
	played 
	ranking 
	goals_for 
	goals_against 
	archive 
	created_at
	updated_at
	user_id
end



def table_states
	name
	archive 
	created_at
	updated_at
end

def table_teammates
	user_id
	group_id
	manager_id
	status 
	accepted_at
	teammate_code
	created_at
	updated_at
	item_id
	item_type
	sub_item_id
	sub_item_type
	archive 
end



def table_timeTABLEs
	day_of_week
	installation_id
	type_id
	starts_at
	ends_at
	timeframe 
	archive 
	created_at
	updated_at
end



def table_types
	name 
	table_type
	table_id
	created_at
	updated_at
end



def table_users
	name
	email 
	identity_url
	language 
	time_zone 
	phone
	login
	teammate_notification 
	message_notification 
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	crypted_password
	password_salt
	persistence_token 
	login_count 
	last_request_at
	last_login_at
	current_login_at
	last_login_ip
	current_login_ip
	private_phone 
	private_profile 
	description
	gender
	birth_at
	archive 
	created_at
	updated_at
	perishable_token 
	last_contacted_at
	active 
	profile_at
	company 
	last_minute_notification 
	city_id 
	email_backup
	sport
	linkedin_url
	linkedin_token
	linkedin_secret
	slug
	validation 
	whatsapp 
end



def table_venues
	name
	starts_at
	ends_at
	time_zone
	marker_id
	enable_comments 
	public 
	photo_file_name
	photo_content_type
	photo_file_size
	photo_updated_at
	description
	archive 
	created_at
	updated_at
	day_light_savings 
	day_light_starts_at
	day_light_ends_at
	slug
	short_name
end










----------------------------------
select first_user_id, second_user_id, first_user_win, second_user_win, same_team, count(*) as total
from (
select schedule_id, first_user_id, second_user_id, first_user_team, winning_team, second_user_team, first_user_win, second_user_win, (first_user_win = second_user_win) as same_team
from (
select distinct a.schedule_id, a.user_id as first_user_id, b.user_id as second_user_id, a.user_x_two as first_user_team, a.one_x_two as winning_team, b.user_x_two as second_user_team, (a.user_x_two = a.one_x_two) as first_user_win, (b.user_x_two = a.one_x_two) as second_user_win
from matches a, matches b 
where a.user_id = 2001 and a.type_id = 1 and a.one_x_two != 'X'
and a.group_score is not null and a.invite_score is not null
and a.schedule_id = b.schedule_id
and a.group_id = b.group_id
and a.type_id = b.type_id
and b.user_id != 2001
UNION ALL
select distinct a.schedule_id, a.user_id as first_user_id, b.user_id as second_user_id, a.user_x_two as first_user_team, a.one_x_two as winning_team, b.user_x_two as second_user_team, (a.user_x_two = a.one_x_two) as first_user_win, (b.user_x_two = a.one_x_two) as second_user_win
from matches a, matches b 
where a.user_id = 2001 and a.type_id = 1 and a.one_x_two != 'X'
and a.group_score is not null and a.invite_score is not null
and a.schedule_id = b.schedule_id
and a.group_id != b.group_id
and a.type_id = b.type_id
and b.user_id != 2001
) as user_match_statistics
) as user_match_statistics_total
group by first_user_id, second_user_id, first_user_win, second_user_win, same_team
order by second_user_id, first_user_win desc, second_user_id







select a_user, b_user, team, count(*) as total
from (
		select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '1' team
		from matches a, matches b 
		where a.type_id = 1
		and a.schedule_id = b.schedule_id
		and a.type_id = b.type_id
		and a.group_id = b.group_id
		and a.user_id = 2001 
		UNION ALL
		select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '0'
		from matches a, matches b 
		where a.type_id = 1
		and a.schedule_id = b.schedule_id
		and a.type_id = b.type_id
		and a.group_id != b.group_id
		and a.user_id = 2001 
) 
as alias
where a_user != b_user
group by a_user, b_user, team
order by b_user, team, total


select an.name, bn.name, team, count(*) as total
from
(
select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '1' team
from matches a, matches b 
where a.type_id = 1
and a.schedule_id = b.schedule_id
and a.type_id = b.type_id
and a.group_id = b.group_id
and a.user_id = 2001 
UNION ALL
select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '0'
from matches a, matches b 
where a.type_id = 1
and a.schedule_id = b.schedule_id
and a.type_id = b.type_id
and a.group_id != b.group_id
and a.user_id = 2001 
) as alias, users an, users bn
where a_user != b_user
and a_user = an.id 
and b_user = bn.id
group by an.name, bn.name, team
order by bn.name, team, total




select an.name, bn.name, team, result, count(*) as total
from
(
select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '1' team, 'W' result
from matches a, matches b 
where a.type_id = 1
and a.schedule_id = b.schedule_id
and a.type_id = b.type_id
and a.group_id = b.group_id
and a.group_score is not null
and a.invite_score is not null
and a.user_id = 2001 
and a.one_x_two = a.user_x_two
UNION ALL
select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '1' team, 'L' result
from matches a, matches b 
where a.type_id = 1
and a.schedule_id = b.schedule_id
and a.type_id = b.type_id
and a.group_id = b.group_id
and a.group_score is not null
and a.invite_score is not null
and a.user_id = 2001 
and a.one_x_two != a.user_x_two
UNION ALL
select distinct a.schedule_id, a.user_id as a_user, b.user_id as b_user, '1' team, 'W' result
from matches a, matches b 
where a.type_id = 1
and a.schedule_id = b.schedule_id
and a.type_id = b.type_id
and a.group_id = b.group_id
and a.group_score is not null
and a.invite_score is not null
and a.user_id = 2001 
and a.one_x_two = 'x'
) as alias, users an, users bn
where a_user != b_user
and a_user = an.id 
and b_user = bn.id
group by an.name, bn.name, team, result
order by bn.name, team, result, total


reservations:

index_zurb.html.erb
calendar_zurb.html.erb
calendar_fill_zurb.html.erb





Host	ec2-107-20-195-105.compute-1.amazonaws.com
Database	dblpmdpstnm8so
User	cbtavkfcyrkbpa
Port	5432
Password	Hide 7z1UCISl1Zm6cjTGWGgoU1wnsI



Host	ec2-107-20-195-105.compute-1.amazonaws.com
Database	dblpmdpstnm8so
User	cbtavkfcyrkbpa
Port	5432
Password	Hide 7z1UCISl1Zm6cjTGWGgoU1wnsI



---------------










# set app offline
$ heroku maintenance:on --app zurb
Maintenance mode enabled.

# restore database
heroku pgbackups:restore HEROKU_POSTGRESQL_JADE b030 --app zurb

# set app online
$ heroku maintenance:off --app zurb
Maintenance mode disabled.



# restore production database on local

***   heroku pgbackups:url --app zurb

***   heroku pgbackups --app zurb

***   heroku pgbackups:url b072 --app zurb

***   curl -o zurb29mar2013.dump "url_in_s3" 
***   curl -o zurb29mar2013.dump "https://s3.amazonaws.com/hkpgbackups/app5730798@heroku.com/b072.dump?AWSAccessKeyId=AKIAIYZ2BP3RBVXEIZDA&Expires=1364583140&Signature=K0svlCRRIy1zUjV5rwC1Ao9Xzew%3D"

***   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d desarrollo_thepista zurb29mar2013.dump









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
http://www.reydelapista.com/club.php?polideportivo=centro%20deportivo%20los%20prunos%20,%20%20gimnasio%20spa%20aqa%20&id=270

http://www.reydelapista.com/clubes.php?club=&_pagi_pg=85


info@centrodeportivolavega.com
centrodeportivolavega.com
Centro Deportivo La Vega

Alborán Golf
alborangolf@alborangolf.com
alborangolf.com


clubgolf@alicantegolf.com
alicantegolf.com
alicante golf

office@clubdegolfaloha.com
Aloha Golf Club
http://www.clubdegolfaloha.com/


http://www.amarillagolf.es/
Amarilla Golf & Country Club
info@amarillagolf.es

info@bonasport.com
info@bonasport.com
info@bonasport.com

info@centrebalmallorca.es
info@centrebalmallorca.es
C.B.E Centre Ball Mallorca


riazorcd1@aytolacoruna.es
C.D. De Riazor



info@calanovagolfclub.com
info@calanovagolfclub.com
http://www.calanovagolfclub.com
Calanova Golf Club



club@salamancagolf.com
Campo De Golf De Salamanca
http://www.salamancagolf.com/



cdlatorre@aytolacoruna.es
Campo Municipal De Golf Torre De Hércules
cdlatorre@aytolacoruna.es



http://www.covibar2.com
escuela_padel@covibar2.com
Centro Deportivo Armando Rodríguez Vallina - Covibar 2

aqa.prunos@gaiagd.com
aqa.prunos@gaiagd.com
Centro Deportivo Los Prunos , Gimnasio Spa Aqa


http://www.ciudadraqueta.com/
C/ Monasterio de El Paular 2, 
28049 Montecarmelo (Madrid)

Télefono: 917 297 922 
Télefono Escuela: 603 208 206
Télefono Restaurante:	672 924 843 
Télefono Eventos: 603 206 477
ciudadraqueta@ciudadraqueta.com



cdlatorre@aytolacoruna.es
Ciudad Deportiva De La Torre



info@camontemar.com
http://www.camontemar.com/
Club Atlético Montemar


http://www.club-brezo-osuna.es/
Club Brezo Osuna
info@club-brezo-osuna.es


http://www.clubcordillera.com
clubcordillera@clubcordillera.com
Club Cordillera


lafresnedaweb@hotmail.com
http://www.lafresneda.com/index.html
la fresnada





Club De Campo Santa Barbara
http://www.santabarbaraclubcampo.com/
info@santabarbaraclubcampo.com


Club De Campo Villa De Madrid
http://www.clubvillademadrid.com
deportes@clubvillademadrid.com


Club De Esgrima De Madrid
www.clubdeesgrimademadrid.com
info@clubdeesgrimademadrid.com



la galera
info.lagalera.net
http://www.lagalera.net/



Club De Golf El Bosque
http://www.elbosquegolf.com




Club De Golf La Peñaza
http://www.golflapenaza.com



Club de Golf La Peñaza
Ctra. Madrid Km. 308 (Desvío Base Aérea)
Apdo. Correos 3039
50080 - Zaragoza
Telf: + 34 976 342 800
Fax: + 34 976 541 907
Administración: administracion@golflapenaza.com


Club De Golf Vista Hermosa
http://www.vistahermosaclubdegolf.com/
info@vistahermosaclubdegolf.com


Club De Tenis Alameda
http://www.padelalameda.com
ctalameda@teleline.es


Club De Tenis De La Salut
http://www.ctlasalut.com
ctlasalut@ctlasalut.com


http://www.clubtenisponferrada.es/index.php?page_id=201
Club Deportivo de Tenis Ponferrada
C\ Sitio de Numancia s/n.
24400 Ponferrada (León)
Tfno/Fax: 987 411 915
Tfno Movil: 696 654 196
info@clubtenisponferrada.es

Club De Tenis Alameda
http://www.padelalameda.com
ctalameda@teleline.es


Club De Tenis Coslada
http://www.teniscoslada.com/



Club De Tenis De La Salut
http://www.ctlasalut.com
ctlasalut@ctlasalut.com



Club De Tenis Estepona
http://www.clubdetenisestepona.com/web/index.com
info@clubdetenisestepona.com



Club De Tenis Tarragona
http://www.tennistarragona.com/
info@tennistarragona.com


Club De Tenis Utrera

http://clubdetenisutrera.wordpress.com/
Email:
tenispadel@gmail.com

Club De Tenis Y Padel Monteverde

http://www.clubdetenismonteverde.com/



Club Deportiva Granadal La Salle
http://www.cdgranadallasalle.com
Teléfono: 957405366
Teléfono móvil: 667017157
Email: info@cdgranadallasalle.com





Club Deportivo Canal De Isabel Ii

http://www.cyii.es



Club Deportivo El Rincón Del Jiu Jitsu

www.elrincondeljiujitsu.com


Club Deportivo Elemental Sportia
http://www.clubsportia.com
asociacion.sportia@gmail.com



Club Deportivo Marisma
http://www.clubdeportivomarisma.com/
marisma@clubdeportivomarisma.com



Club Deportivo Metropolitano
http://www.cdmetropolitano.com
recepcion@cdmetropolitano.com

Club Deportivo Pamplona
http://www.cdpamplona.com
info@cdpamplona.com




Club Deportivo Vasconia
http://www.cdvasconia.com/
club@cdvasconia.com


Club Deportivo Zamarat
http://www.cdzamarat.es/index.html
cdzamarat@hotmail.com


Club El Estudiante

http://www.clubelestudiante.com
info@clubelestudiante.com





Club Esportiu Hispano-FrancÉs
cdhispanofr.com
info@cdhispanofr.com


Club Fluvial
http://www.clubfluviallugo.com
fluvialarrobaclubfluviallugo.com


Club Juliana
http://www.julianaclub.es
info@julianaclub.es


Club Social Torrelago
http://www.clubtorrelago.com/
oficina@clubtorrelago.com


Club Tenis Y Padel Ciudad Deportiva Jarama
cdjarama.es
escuelas@cdjarama.es



Club Terrassa Sport Futbol
http://www.terrassasports.es
padel@terrassasports.es




Club Voleibol Teruel
http://www.voleibolteruel.com/
club@voleibolteruel.com



Club Zaudin Golf
http://www.clubzaudingolf.com
comercial@clubzaudingolf.com


Complejo Deportivo Aqa Arteixo
http://gaiagd.com/
AQA Los Prunos
Avda. de los Prunos 98
28042, Madrid - Madrid
Tlf: 917 432 001
Fax: 917 432 002
» Ver localización en Google Maps 
aqa.prunos@gaiagd.com



Complejo Deportivo Aqa Benetusser
http://gaiagd.com/




Complexo Acuatico Acea De Ama
http://www.aquama.net
info@aquama.net



Deportivo Sansueña Sierra
http://www.clubsansuena.com
info@clubsansuena.com


Dreampeaks: Club De Montaña Y Escalada

http://www.dreampeaks.org/
info@dreampeaks.org


El Reino De Don Quijote Golf

http://www.elreinodedonquijote.com
recepcion_golf@elreinodedonquijote.com



El Robledal Golf

http://www.elrobledalgolf.com
elrobledalgolf@aymerichgolf.com


Escalona Golf Village
http://www.escalonagolfvillage.com
reservas@escalonagolf.com


Estadio Miralbueno El Olivar
http://www.elolivar.com/



Foressos Golf
http://www.foressosgolf.com
foressosgolf@aymerichgolf.com


Foressos Golf

http://www.foressosgolf.com
foressosgolf@aymerichgolf.com


fuensanta
clubfuensanta@clubfuensanta.com
clubfuensanta@clubfuensanta.com



FundaciÓ Brafa
brafa@brafa.org


G8 Sport Club
http://www.g8sportclub.com/
info@g8sportclub.com


Golf & Spa Bonalba

http://www.golfbonalba.com
golfbonalba@golfbonalba.com


Golf En La Manga Club

http://www.lamangaclub.es/
golf@lamangaclub.es

Golf Olivar De La Hinojosa

http://www.golfolivar.com/
go@golfolivar.com




Golf Park Entertainment

http://www.golfpark.es
info@golfpark.es

Golf Park Mallorca

http://www.golfparkmallorca.com
infopuntiro@golfpark.es


Golf Santa Ponsa 2

http://www.habitatgolf.es
golf2@habitatgolf.es


Lauro Golf

http://www.laurogolf.com/
info@laurogolf.com


Marbella Golf And Country Club

http://www.marbellagolf.com
info@marbellagolf.com

Meaztegui Golf

www.meaztegi-golf.com
meaztegi-golf@meaztegi-golf.com


Momo Sports Club Cardenal Cisneros

http://www.momosportsclub.com
info@momosportsclub.com


Momo Sports Club La Dehesa

http://www.momosportsclub.com
info@momosportsclub.com

Open Sports Club

http://www.opensportsclub.com/
openclub@sanchez-casal.com


Organización Deportiva Velódrom
bcn@bcndeportiva.com
bcn@bcndeportiva.com



Panoramica Club De Golf Y Country Club

http://www.panoramicaclubdegolf.com
http://www.panoramicaclubdegolf.com/contacto/


Padel Club Suizo

http://www.padelclubsuizo.com/
info@padelclubsuizo.com


Pablo Semprún Sport Center

http://www.pablosemprunsportcenter.com
pssc@pablosemprunsportcenter.com


Polideportivo Ciudad De Algeciras
info@pmdalgeciras.org
info@pmdalgeciras.org



Polideportivo Ipurua

http://www.eibarkirola.com
pmdeibar@eibarkirola.com





Polideportivo Municipal Barrio De Las Flores
barrioflores@aytolacoruna.es
barrioflores@aytolacoruna.es


Polideportivo Municipal Lobete
polideportivolobete@logro-o.org
polideportivolobete@logro-o.org



Real Canoe Natación Club
realcanoe@realcanoe.es
realcanoe@realcanoe.es




Real Club De Golf De Las Palmas

http://www.realclubdegolfdelaspalmas.com
rcglp@realclubdegolfdelaspalmas.com


Real Club De Golf De Sevilla

http://www.sevillagolf.com
deportes@sevillagolf.com

Real Club De Golf De Sevilla
 
http://www.sevillagolf.com
deportes@sevillagolf.com


Real Club De Golf El Prat

http://www.realclubdegolfelprat.com
rcgep@rcgep.com


Real Club De Tenis Lopez Maeso

http://www.tenislopezmaeso.com
info@tenislopezmaeso.com


Real Club Nautico De Gran Canaria
http://www.rcngc.com
rcngc@rcngc.com


Real Golf Club De Zarautz
http://www.golfzarauz.com
info@golfzarauz.com


Real Sociedad Hípica Española Club De Campo
http://www.rshecc.es
deportes@rshecc.es


Real Zaragoza Club De Tenis
http://www.rzct.com/
rzct@rzct.com


Recinto Ferial Juan Carlos I De Madrid
http://www.ifema.es/default.html
infoifema@ifema.es


Reebook Sports Club La Finca
http://www.reebokclub.com/
monica.maria@reebokclub.com



Saude Club
http://www.saudeclub.com
info@saudeclub.com


Sherry Golf Jerez
http://www.sherrygolfjerez.com
info@sherrygolf.com


Spacio Deportivo El Capricho
http://www.spaciodeportivo.com
asesor@spaciodeportivo.com



Sport Center Manolo Santana
http://www.santanacenter.com
http://www.santanacenter.com/#



Stadium Venecia

http://www.stadiumvenecia.com
info@stadiumvenecia.com


Wellsport Club

http://www.wellsportclub.com
general@wellsportclub.com



Centro Deportivo Los Prunos , Gimnasio Spa Aqa
aqa.prunos@gaiagd.com



http://adsaludycultura.com/
info@adsaludycultura.com
