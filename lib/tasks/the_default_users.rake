
# create a default set of users
# to run:    rake the_default_users

desc "create three new default users"
task :the_default_users => :environment do |t|

	I18n.locale = "es"

	1..3.times do |count|

		the_name =  "#{I18n.t(:user)} #{count+1}"
		the_email = "#{the_name.gsub(' ', '_')}@haypista.com"

		new_user = User.new
		new_user.id = 											count+1
		new_user.name = 										the_name
		new_user.email =										the_email
		new_user.teammate_notification = 		false
		new_user.message_notification = 		false
		new_user.private_phone = 						true
		new_user.private_profile = 					true
		new_user.email_backup = 						the_email

		new_user.password = Base64::encode64(the_email)
		new_user.password_confirmation = Base64::encode64(the_email)

		new_user.save!

		puts the_name

		all_groups = Group.where('archive = false')
		all_groups.each do |group|

			new_user.has_role!(:member,  group)        
			Scorecard.create_user_scorecard(new_user, group)    
			GroupsUsers.join_team(new_user, group)

			group.schedules.each do |schedule|
				Match.create_schedule_match(schedule)
			end

		end

	end

end