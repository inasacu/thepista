# to run:  heroku run rake the_scorecard_group_user --app zurb

desc "archive groups_users from teams where players did not a game..."
task :the_scorecard_group_user => :environment do |t|

	counter = 0
	the_archives = []

	# SCORECARDS
	@archive = Scorecard.find(:all, :conditions => ["archive = false and group_id not in (select id from groups)"])
	@archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# GROUPS_USERS
	@archive = GroupsUsers.find(:all, :conditions => ["archive = false and group_id not in (select id from groups)"])
	@archive.each do |group_user|
		puts "(#{counter+=1}): #{group_user.user_id}, #{group_user.group_id}"

		sql = "UPDATE groups_users set archive = true WHERE group_id = #{group_user.group_id} and user_id = #{group_user.user_id}"
		ActiveRecord::Base.connection.insert_sql sql
	end



	the_scorecards = Scorecard.find(:all, :select => "distinct scorecards.*, users.name as user_name, groups.name as group_name",
	:joins => "JOIN users on users.id = scorecards.user_id JOIN groups on groups.id = scorecards.group_id",
	:conditions => "scorecards.archive = false and users.id > 3")
	the_scorecards.each do |scorecard|

		archive = GroupsUsers.find(:first, :conditions => ["archive = false and group_id = ? and user_id = ?", scorecard.group_id, scorecard.user_id])
		if archive.nil?
			puts "(#{counter +=1}) #{scorecard.user_id} #{scorecard.group_id} #{scorecard.user_name} #{scorecard.group_name}"

			scorecard.archive = true
			scorecard.save
		end
		
	end

		# sql = "DELETE from groups_users where archive = true"
		# ActiveRecord::Base.connection.insert_sql sql

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
