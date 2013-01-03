# to run:    heroku run rake the_remove_archive_data --app zurb

desc "remove all archived files not needed"
task :the_remove_archive_data => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	the_archives = []
	counter = 1

	@archive = Cast.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Challenge.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = ChallengesUsers.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	if (Challenge.find(:all).count < 1)
		# @archive = ChallengesUsers.find(:all, :condito)
		# @archive.each {|archive_file| the_archives << archive_file}
		
		sql = "DELETE FROM challenges_users"
		ActiveRecord::Base.connection.insert_sql sql
	end
	
	@archive = Game.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Standing.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Cup.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Match.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Fee.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Payment.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Schedule.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Role.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = RolesUsers.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	the_archives.each do |the_archive|
		puts " (#{counter}). #{the_archive.class.to_s}: #{the_archive.id} archived files REMOVED"
		the_archive.destroy
		counter += 1
	end

	the_archives = []

end

