# to run:  heroku run rake the_replace_email_name --app zurb

desc "replace user name w/ email address is in the name"
task :the_replace_email_name => :environment do |t|

	counter = 0
	the_users = User.find(:all)
	the_users.each do |user|
		
		if user.name == user.email
		
			puts "(#{counter+=1}) #{user.name}, #{user.email} "
			user.email_to_name
			puts "(#{counter}) #{user.name}, #{user.email} "
			user.save
		end

	end
	
end