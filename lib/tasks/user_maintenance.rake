# to run:    sudo rake the_user_maintenance

desc "  # clear foto for dev and test"
task :the_user_maintenance => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
   
  unless production?
    users = (User.find :all).collect {|user| user unless user.email.blank? }.compact
    users.each do |user|
      puts user.name
      user.photo_file_name = nil
      user.photo_content_type = nil
      user.photo_file_size = nil
      user.photo_updated_at = nil
      user.save!
    end
  
    Group.find(:all).each do |group|
      puts group.name
      group.photo_file_name = nil
      group.photo_content_type = nil
      group.photo_file_size = nil
      group.photo_updated_at = nil
      group.save!
    end
  end

end

