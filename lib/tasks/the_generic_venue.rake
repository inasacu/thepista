# to run:    heroku run rake the_generic_venue --app zurb

desc "create a generic venue with installation and timetable..."
task :the_generic_venue => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	# select * from venues
	# select * from installations  order by id desc
	# select * from timetables order by id desc
	# select * from timetables where installation_id = 999
	# delete from timetables where installation_id = 999

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


	@groups = Group.find(:all, :conditions => "installation_id is null")
	@groups.each do |group|
		group.installation_id = 999
		group.save
	end

end












