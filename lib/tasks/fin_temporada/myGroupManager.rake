# to run:    rake myGroupManager 



desc "add myself as manager to group_id = 14"
task :myGroupManager => :environment do |t|

	##############################################################################################################################################################################
	# remove in production...
	# select * from roles_users where user_id = 2001	and role_id in (	select id	from roles where name = 'manager' 	and authorizable_type = 'Group'	and authorizable_id = 14)

	RolesUsers.create(:user_id => 2001, :role_id => 72608)
  ##############################################################################################################################################################################
	
end
