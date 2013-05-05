# to run:    heroku run rake the_installation_timetable -a thepista

desc "create a new veneu, installations and timetables"
task :the_installation_timetable => :environment do |t|

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

