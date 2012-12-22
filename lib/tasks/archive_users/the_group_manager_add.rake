# to run:    rake the_group_manager_add 



desc "add myself as manager to group_id = 14"
task :the_group_manager_add => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	##############################################################################################################################################################################
	# remove in production...
	# select * from roles_users where user_id = 2001	and role_id in (	select id	from roles where name = 'manager' 	and authorizable_type = 'Group'	and authorizable_id = 14)

	RolesUsers.create(:user_id => 2001, :role_id => 72608)
  ##############################################################################################################################################################################

	# group_id = 14
	# counter = 0
	# 
	# # GROUPS
	# group = Group.find(group_id)
	# 
	# the_scorecards = Scorecard.find(:all, :conditions => ["group_id = ?", group])
	# 
	# the_scorecards.each do |scorecard|
	# 	scorecard.update_attributes(:wins => 0, :losses => 0, :draws => 0, :played => 0, :assigned => 0,
	#                               :points => 0, :previous_points => 0, :previous_played => 0, 
	#                               :goals_for => 0, :goals_against => 0, :goals_scored => 0)
	# 
	# 	puts "#{scorecard.id}  update #{scorecard.class.to_s} files (#{counter+=1})"
	# end
	
end
