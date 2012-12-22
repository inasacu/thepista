# to run:    heroku run rake the_archive_user_match --app zurb

desc "ARCHIVE user matches, scorecard"
task :the_archive_user_match => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	the_archives = []

	# USERS
	the_archive_false = User.find(:all, :conditions => "archive = false")
	the_archive_true = User.find(:all, :conditions => "archive = true")

	# MATCHES
	@archive = Match.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Match.find(:all, :conditions => ["archive = false and user_id not in (?)", the_archive_false])
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# SCORECARDS
	@archive = Scorecard.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	@archive.each {|archive_file| the_archives << archive_file}

	@archive = Scorecard.find(:all, :conditions => ["archive = false and user_id not in (?)", the_archive_false])
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

end


def set_all_to_archive(the_archives)

	counter = 1
	the_archives.each do |the_archive|
		puts "  #{counter}: ARCHIVE #{the_archive.class.to_s} #{the_archive.id}"
		the_archive.archive = true
		the_archive.save
		counter += 1
	end

	the_archives = []
	return the_archives 

end