# to run:  heroku run rake reduce_team_sizes --app zurb

desc "archive groups_users from teams where players did not a game..."
task :reduce_team_sizes => :environment do |t|

	counter = 0
	the_archives = []
	
	begin_range = PRICE_RANGE_UNDER_50.first
	end_range = PRICE_RANGE_UNDER_50.last - DEFAULT_GROUP_USERS.length

	the_scorecards = Scorecard.find(:all, :select => "distinct scorecards.*", 
																	:joins => "JOIN groups_users on groups_users.group_id = scorecards.group_id", 
																	:conditions => ["groups_users.group_id in (
																			select group_id
																			from groups_users
																			group by group_id
																			having count(*) > ?
																		)
																		and scorecards.user_id not in (?)
																		and scorecards.played < 1", end_range, DEFAULT_GROUP_USERS])			
																		
		the_scorecards.each do |scorecard|
			@archive = GroupsUsers.find(:all, :conditions => ["group_id = ? and user_id = ?", scorecard.group_id, scorecard.user_id])
				
			@archive.each do |group_user|
				puts "(#{counter+=1}): #{group_user.user_id}, #{group_user.group_id}"
				
				sql = "UPDATE groups_users set archive = true WHERE group_id = #{scorecard.group_id} and user_id = #{scorecard.user_id}"
				ActiveRecord::Base.connection.insert_sql sql
				
			end
		end
		
		the_archive_true = GroupsUsers.find(:all, :conditions => "archive = true")

		# MATCHES
		the_archive_true.each do |the_group_user|

			@archive = Match.find(:all, :conditions => ["group_id = ? and user_id = ?", the_group_user.group_id, the_group_user.user_id])
			@archive.each {|archive_file| the_archives << archive_file}
			the_archives = set_all_to_archive(the_archives)

			# SCORECARDS
			@archive = Scorecard.find(:all, :conditions => ["group_id = ? and user_id = ?", the_group_user.group_id, the_group_user.user_id])
			@archive.each {|archive_file| the_archives << archive_file}
			the_archives = set_all_to_archive(the_archives)
		
		end
		
		sql = "DELETE from groups_users where archive = true"
		ActiveRecord::Base.connection.insert_sql sql

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