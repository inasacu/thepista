# to run:    rake update_user_city

desc "update user city"
task :update_user_city => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  User.find(:all, :conditions => "city_id is null").each do |user|
    user.city_id = 1
    user.save
    puts user.name
  end

end




