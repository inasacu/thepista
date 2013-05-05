# to run:    heroku run rake the_archive_role -a thepista

desc "ARCHIVE dependent records to already archived"
task :the_archive_role => :environment do |t|

	the_archives = []
	counter = 0

	# set all ROLES to archive = false
	sql = "UPDATE roles set archive = false"
	ActiveRecord::Base.connection.insert_sql sql

	# set all ROLES_USERS to archive = false
	sql = "UPDATE roles_users set archive = false"
	ActiveRecord::Base.connection.insert_sql sql



	# GROUPS
	the_model_records = Group.find(:all)

	# ROLES GROUPS
	@archive = Role.find(:all, :conditions => ["archive = false and authorizable_type = 'Group' and authorizable_id not in (?)", the_model_records])
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# ROLES CUPS, CHALLENGES, CLASSIFIEDS, SCHEDULES
	@archive = Role.find(:all, :conditions => "archive = false and authorizable_type in ('Cup', 'Challenge', 'Classified', 'Schedule')")
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	#ROLES subscriptions
	@archive = Role.find(:all, :conditions => "archive = false and name = 'subscription'")
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)


	# ROLES
	the_archive_true = Role.find(:all, :conditions => "archive = true")

	# ROLES_USERS
	the_archive_true.each do |archive_file|
		sql = "update roles_users set archive = true where archive = false and role_id = #{archive_file.id}"
		puts "#{archive_file.id}  ARCHIVE #{archive_file.class.to_s} User files (#{counter += 1})"
		ActiveRecord::Base.connection.insert_sql sql
	end

	
	# DESTROY all ROLES and ROLES_USERS
	sql = "DELETE FROM roles WHERE archive = true"
	ActiveRecord::Base.connection.insert_sql sql
	
	sql = "DELETE FROM roles_users WHERE archive = true"
	ActiveRecord::Base.connection.insert_sql sql

end

def set_all_to_archive(the_archives)

	counter = 0
	the_archives.each do |the_archive|
		puts "#{the_archive.id}  ARCHIVE #{the_archive.class.to_s} files (#{counter += 1})"
		the_archive.archive = true
		the_archive.save
	end

	the_archives = []
	return the_archives 

end