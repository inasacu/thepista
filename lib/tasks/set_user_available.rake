# to run:    sudo rake set_user_available

desc "  # set all users as available"
task :set_user_available => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  users = User.find(:all, :conditions =>"available = false and archive = false")
  users.each do |user|
    puts user.name
    user.available = true
    user.save!
  end

end

