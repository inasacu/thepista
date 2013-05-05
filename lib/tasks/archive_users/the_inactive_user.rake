# to run:    rake the_inactive_user

desc "set user email notices to false for user that are not active"
task :the_inactive_user => :environment do |t|

	last_six_months = TIME_SIX_MONTHS_AGO
	last_year = 12.months.ago

  the_users = []
  counter = 0

	# email backup
	the_user = User.find(:all, :conditions => "email_backup is null and email is not null")
	the_user.each do |user|
		puts "EMAIL BACKUP user => #{user.name}"
		user.email_backup = user.email
		user.save
	end

	puts "users who have not logged in since #{last_six_months}"
	all_users = User.find(:all, :conditions => ["id != 2901 and last_login_at < ? and (archive is null or archive = false)", last_six_months], :order => "last_login_at desc")
	all_users.each do |the_user|
		unless the_users.include?(the_user)

			# players on this list who have not played in the last 12 months
			add_user = User.find(:first, :joins => "LEFT JOIN matches on matches.user_id = users.id", :conditions => ["matches.user_id = ? and matches.status_at >= ? and matches.type_id = 1", the_user, last_year])

			unless add_user.nil?

				#disregard any player who is currently in an active team
				active_team_player = User.find(:first, :conditions => ["archive = false and id not in (select distinct user_id from groups_users where archive = false)"])

				unless active_team_player.nil?

					puts "#{the_user.name} => #{the_user.last_login_at}"
					the_users << active_team_player

				end
			end
		end
	end


  
   # the_users.each do |the_user|
   #   puts "#{the_user.name} - #{counter+=1}"
   # end
  
  # 
  #  counter = 0
  #  the_inactives = User.find(:all, :conditions => ["id not in (?) and archive=false", the_users])
  #  the_inactives.each do |the_user|
  #    puts "#{the_user.name}"
  # 
  #    the_user.archive = true
  #    the_user.save
  #    counter += 1
  #  end
  # 
  #  puts ""
  #  puts "total users #{counter}"

end
