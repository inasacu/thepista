# to run:    heroku run rake the_user_email_backup --app zurb

desc "users w/o email backup get updated..."
task :the_user_email_backup => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	# User.find(:all, :conditions => "email_backup is null").each do |user|
	# 	puts "#{user.name} - #{user.email}"
	# 	user.email_backup = user.email
	# 	user.save!
	# end
	
	User.find(:all, :conditions => "name = email").each do |user|
		puts "#{user.name} - #{user.email}"
		user.email_to_name if user.name.include?('@')
		user.save!		
	end

end