# to run:    rake the_remove_user

desc "ARCHIVE dependent records to already archived"
task :the_remove_user => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	has_to_archive = true

	user = User.find(:first, :conditions => ["id = 3060 and archive = false"])
	unless user.nil?
	puts "archive user => #{user.name} "
	user.archive = true
	user.email = 'remove_user@gmail.com'
	user.name= 'user_archived'
	user.save! if has_to_archive
end

end
