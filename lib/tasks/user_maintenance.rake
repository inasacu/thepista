# to run:    sudo rake the_user_maintenance

desc "creating a wall, also archive all unactive users...for each user. call with RAILS_ENV=production or it defaults to development"
task :the_user_maintenance => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  unless production?
    users = (User.find :all).collect {|user| user unless user.email.blank? }.compact
    users.each do |user|
      # clear foto for dev and test
      user.photo_file_name = nil
      user.photo_content_type = nil
      user.photo_file_size = nil
      user.photo_updated_at = nil
      user.save!


    end
    
  end

end

