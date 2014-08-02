# to run:    heroku run rake final_temporada_borrar_archive --app zurb

desc "remove all end of season archived files"
task :final_temporada_borrar_archive => :environment do |t|

	the_archives = []
	counter = 1

	@archive = Cast.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Challenge.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = ChallengesUsers.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}
	
	@archive = Group.find(:all, :conditions => ["archive = true"])
	@archive.each {|archive_file| the_archives << archive_file}
	
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

	if (Challenge.find(:all).count < 1)
		sql = "DELETE FROM challenges_users"
		ActiveRecord::Base.connection.insert_sql sql
	end
	
	the_archives.each do |the_archive|
		puts " (#{counter}). #{the_archive.class.to_s}: #{the_archive.id} archived files REMOVED"
		the_archive.destroy
		counter += 1
	end

	the_archives = []

end

