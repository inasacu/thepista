# to run:    sudo rake the_second_user_account

desc "this rake job is to convert a user who has several accounts"
desc "this job will take user original account and replace the id for a previous account created id"

task :the_second_user_account => :environment do |t|

	ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

	the_original_user = User.find(:first, :conditions => "email = 'julien.tisseau@chep.com'")
	the_new_user = User.find(:first, :conditions => "email = 'julientondu@hotmail.com'")
	the_max_user = User.find(:first, :conditions => "id = (select max(id) from users)")

	is_user_available =  !the_original_user.nil? and !the_new_user and !the_max_user

	if is_user_available

		the_original_id = the_original_user.id.to_i
		the_new_id = the_new_user.id.to_i
		the_max_plus_one_id = the_max_user.id.to_i + 1

		puts " ------------------------ original information  ------------------------ "
		puts "#{the_original_user.id} - #{the_original_user.name} - #{the_original_user.email} => [#{the_original_id}]"
		puts "#{the_new_user.id} - #{the_new_user.name} - #{the_new_user.email} => [#{the_new_id}]"
		puts "#{the_max_user.id} - #{the_max_user.name} => [#{the_max_plus_one_id}]"

		result = ActiveRecord::Base.connection.update_sql( "update users set id=#{the_max_plus_one_id} where id=#{the_original_id}" )
		result = ActiveRecord::Base.connection.update_sql( "update users set id=#{the_original_id} where id=#{the_new_id}" )
		result = ActiveRecord::Base.connection.update_sql( "update users set id=#{the_new_id} where id=#{the_max_plus_one_id}" )

		the_original_change = User.find(:first, :conditions => "email = 'julien.tisseau@chep.com'")
		the_new_change = User.find(:first, :conditions => "email = 'julientondu@hotmail.com'")

		puts " ------------------------ final changes  ------------------------ "
		puts "#{the_original_change.id} - #{the_original_change.name} - #{the_original_change.email} => [#{the_original_id}]"
		puts "#{the_new_change.id} - #{the_new_change.name} - #{the_new_change.email} => [#{the_new_id}]"

	end

end
