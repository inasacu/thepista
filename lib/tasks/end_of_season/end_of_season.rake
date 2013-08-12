# to run:    heroku run rake the_end_of_season --app zurb


task :the_end_of_season => :environment do
	
	desc "ARCHIVE all records related to group then reset group archive to false"
	puts "end of season group archive... A:  #{Time.zone.now}"
	Rake::Task['the_end_of_season_group_archive'].invoke
	puts "end of season group archive... B:  #{Time.zone.now}"

	desc "ARCHIVE all records related to group then reset group archive to false"
	puts "end of season group remove... A:  #{Time.zone.now}"
	Rake::Task['the_end_of_season_group_remove'].invoke
	puts "end of season group remove... B:  #{Time.zone.now}"
	
	desc "ARCHIVE dependent records to already archived end of season records"
	puts "end of season role archive and remove A:  #{Time.zone.now}"
	Rake::Task['the_archive_role'].invoke
	puts "end of season role archive and remove B:  #{Time.zone.now}"
		
end

