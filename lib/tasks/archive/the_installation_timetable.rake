# to run:    heroku run rake the_installation_timetable -a thepista

desc "create a new veneu, installations and timetables"
task :the_installation_timetable => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

# # Centro Deportivo Municipal La Elipa
# 	@new_venue = Venue.new
# 	@new_venue.name = 'Centro Deportivo Municipal La Elipa'
# 	@new_venue.short_name = 'C.D.M. La Elipa'
# 	@new_venue.starts_at = '2012-09-20 06:00:00'
# 	@new_venue.ends_at = '2012-09-20 21:30:00'
# 	@new_venue.marker_id = 48
# 	# @new_venue.description = 'Forma de Gestión
# 	# 													Directa, por parte del Ayuntamiento de Madrid
# 	# 													Superficie - 159.000 m2
# 	# 													
# 	# 													EQUIPAMIENTOS
# 	# 													Unidades Deportivas al aire libre  
# 	# 													2 Campos de Fútbol (de césped artificial) 
# 	# 													2 Campos de Fútbol 7 (de césped artificial) 
# 	# 													4 Pistas de Pádel
# 	# 													10 Pistas de Tenis
# 	# 													11 Tenis Mesa
# 	# 													Unidades Deportivas Cubiertas
# 	# 													Frontón
# 	# 													Pabellón Polideportivo'
# 	@new_venue.save
# 
# # Campo 1 A
# 	@new_installation = Installation.new
# 	@new_installation.name = 'Campo 1 A'
# 	@new_installation.venue_id = @new_venue.id
# 	@new_installation.marker_id = @new_venue.marker_id
# 	@new_installation.sport_id = 2
# 	@new_installation.starts_at = @new_venue.starts_at
# 	@new_installation.ends_at = @new_venue.ends_at
# 	@new_installation.timeframe = 1
# 	@new_installation.fee_per_pista = 30.6
# 	@new_installation.fee_per_lighting = 3.25
# 	@new_installation.public = true
# 	@new_installation.lighting = true
# 	@new_installation.outdoor = true
# 	# @new_installation.description = 'Campo de Fútbol 11 - Cesped Artificial'
# 	# @new_installation.conditions = 'Requiere botas especificas para cesped Artificial'
# 	@new_installation.save
# 
# # Campo 1 B
# 	@new_installation = Installation.new
# 	@new_installation.name = 'Campo 1 B'
# 	@new_installation.venue_id = @new_venue.id
# 	@new_installation.marker_id = @new_venue.marker_id
# 	@new_installation.sport_id = 2
# 	@new_installation.starts_at = @new_venue.starts_at
# 	@new_installation.ends_at = @new_venue.ends_at
# 	@new_installation.timeframe = 1
# 	@new_installation.fee_per_pista = 30.6
# 	@new_installation.fee_per_lighting = 3.25
# 	@new_installation.public = true
# 	@new_installation.lighting = true
# 	@new_installation.outdoor = true
# 	# @new_installation.description = 'Campo de Fútbol 11 - Cesped Artificial'
# 	# @new_installation.conditions = 'Requiere botas especificas para cesped Artificial'
# 	@new_installation.save
# 
# # Campo 7 A
# 	@new_installation = Installation.new
# 	@new_installation.name = 'Campo 7 A'
# 	@new_installation.venue_id = @new_venue.id
# 	@new_installation.marker_id = @new_venue.marker_id
# 	@new_installation.sport_id = 1
# 	@new_installation.starts_at = @new_venue.starts_at
# 	@new_installation.ends_at = @new_venue.ends_at
# 	@new_installation.timeframe = 1
# 	@new_installation.fee_per_pista = 30.6
# 	@new_installation.fee_per_lighting = 3.25
# 	@new_installation.public = true
# 	@new_installation.lighting = true
# 	@new_installation.outdoor = true
# 	# @new_installation.description = 'Campo de Fútbol 7 - Cesped Artificial'
# 	# @new_installation.conditions = 'Requiere botas especificas para cesped Artificial'
# 	@new_installation.save
# 
# # Campo 7 B
# 	@new_installation = Installation.new
# 	@new_installation.name = 'Campo 7 B'
# 	@new_installation.venue_id = @new_venue.id
# 	@new_installation.marker_id = @new_venue.marker_id
# 	@new_installation.sport_id = 1
# 	@new_installation.starts_at = @new_venue.starts_at
# 	@new_installation.ends_at = @new_venue.ends_at
# 	@new_installation.timeframe = 1
# 	@new_installation.fee_per_pista = 30.6
# 	@new_installation.fee_per_lighting = 3.25
# 	@new_installation.public = true
# 	@new_installation.lighting = true
# 	@new_installation.outdoor = true
# 	# @new_installation.description = 'Campo de Fútbol 7 - Cesped Artificial'
# 	# @new_installation.conditions = 'Requiere botas especificas para cesped Artificial'
# 	@new_installation.save
# 	
	
	# generate new slugs
	Schedule.find_each(&:save)
	User.find_each(&:save)
	Marker.find_each(&:save)
	Venue.find_each(&:save)
	Installation.find_each(&:save)

	@original_installation = Installation.find(1)
	@new_venue = Venue.find(2)
	
	@timetables = Timetable.find(:all, :joins => "JOIN types on timetables.type_id = types.id", 
		:conditions => ["types.table_type = 'Timetable' and installation_id = ?", @original_installation], :order => "timetables.installation_id, types.id")
		
		

	@new_venue.installations.each do |installation|

		@timetables.each do |timetable|

			@new_timetable = Timetable.new			
			@new_timetable.installation_id = installation.id
			@new_timetable.type_id = timetable.type_id
			@new_timetable.starts_at = timetable.starts_at
			@new_timetable.ends_at = timetable.ends_at
			@new_timetable.timeframe = timetable.timeframe

			the_timetable = Timetable.find(:first, :conditions => ["installation_id = ? and type_id = ? and starts_at = ? and ends_at = ? and timeframe = ?", 
											@new_timetable.installation_id, @new_timetable.type_id, @new_timetable.starts_at, @new_timetable.ends_at, @new_timetable.timeframe])

			if the_timetable.nil?
				puts "#{@new_timetable.installation_id}, #{@new_timetable.type_id}, #{@new_timetable.starts_at}, #{@new_timetable.ends_at}, #{@new_timetable.timeframe}"
				@new_timetable.save
			end

		end

	end



end

