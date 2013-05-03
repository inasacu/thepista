# to run:    heroku run rake the_generic_venue --app zurb

desc "create a generic venue with installation and timetable..."
task :the_generic_venue => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	# select * from venues
	# select * from installations  order by id desc
	# select * from timetables order by id desc
	# select * from timetables where installation_id = 999
	# 
	# delete from venues where id > 500;
	# delete from installations where id > 500;
	# delete from timetables where installation_id = 999;


	# insert into venues (id, name, starts_at, ends_at, marker_id, description, short_name, created_at, updated_at) 
	# values (999, 'Centro Deportivo Generico', '2013-01-01 06:00:00', '2013-01-01 23:00:00', 2, 'Centro Deportivo Generico', 
	# 	'C.D.Generico', '2013-01-01 06:00:00', '2013-01-01 06:00:00')

	# insert into installations (id, name, venue_id, sport_id, marker_id, starts_at, ends_at, timeframe, fee_per_pista, fee_per_lighting,  description, conditions)
	# values (999, 'Campo 1', 999, 1, 2, '2013-01-01 06:00:00', '2013-01-01 23:00:00', 1, 40, 5, 'Campo de Fútbol 7 - Cesped Artificial', 'Requiere botas especificas para cesped Artificial')


	# sql = "insert into venues (id, name, starts_at, ends_at, marker_id, description, short_name) 
	# values (999, 'Centro Deportivo Generico', '2013-01-01 06:00:00', '2013-01-01 23:00:00', 2, 'Centro Deportivo Generico', 'C.D.Generico')"
	# ActiveRecord::Base.connection.insert_sql sql


	@venue = Venue.find(999)
	unless @venue.nil?

		# sql = "insert into installations (id, name, venue_id, sport_id, marker_id, starts_at, ends_at, timeframe, fee_per_pista, fee_per_lighting,  description, conditions)
		# values (999, 'Campo 1', 999, 1, 2, '2013-01-01 06:00:00', '2013-01-01 23:00:00', 1, 40, 5, 'Campo de Futbol 7 - Cesped Artificial', 'Requiere botas especificas para cesped Artificial')"
		# ActiveRecord::Base.connection.insert_sql sql

		@installation = Installation.find(999)

		unless @installation.nil?

			@timetables = Timetable.find(:all, :conditions => "installation_id = 1")
			@timetables.each do |timetable|
				@new_timetable = Timetable.new
				@new_timetable.installation_id = 999
				@new_timetable.type_id = timetable.type_id
				@new_timetable.starts_at = timetable.starts_at
				@new_timetable.ends_at = timetable.ends_at
				@new_timetable.save
			end

			puts "venue 999, installation 999 and timetames w/ installation 999 created..."	

		end

	end


	@groups = Group.find(:all, :conditions => "installation_id is null")
	@groups.each do |group|
		group.installation_id = 999
		group.save
	end

end












