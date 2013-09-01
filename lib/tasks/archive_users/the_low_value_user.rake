# to run:  heroku run rake the_low_value_user --app zurb

desc "ARCHIVE low user rate"
task :the_low_value_user => :environment do |t|

	the_archives = []
	counter = 0

	the_users = User.find(:all, :conditions => "id not in (1,2,3,2901) 
																							and email not like '%hotmail%'
																							and email not like '%gmail%' 
																							and email not like '%yahoo%'	
																							and email not like '%msn%'") 
	the_users.each do |user|
		user.archive = true
		puts "(#{counter+=1}): #{user.name}, #{user.email}"
		user.save
	end 
	
	# USERS
	the_archive_true = User.find(:all, :conditions => "archive = true")

	# MATCHES
	archive = Match.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# SCORECARDS
	@archive = Scorecard.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)
	
	# CASTS
	archive = Cast.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# STANDINGS
	archive = Standing.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	# ROLES_USERS
	archive = RolesUsers.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	# GROUPS_USERS
	archive = GroupsUsers.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	# CHALLENGES_USER
	archive = ChallengesUsers.find(:all, :conditions => ["archive = false and user_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}
	

	sql = "DELETE from users where archive = true"
	ActiveRecord::Base.connection.insert_sql sql
	
end


def set_all_to_archive(the_archives)

	counter = 1
	the_archives.each do |the_archive|
		puts "  #{counter}: ARCHIVE #{the_archive.class.to_s} #{the_archive.id}"
		the_archive.archive = true
		# the_archive.save
		counter += 1
	end

	the_archives = []
	return the_archives 

end