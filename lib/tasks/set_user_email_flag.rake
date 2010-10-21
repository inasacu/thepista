# to run:    sudo rake the_email_flag

desc "turn of email notices for specific users"
task :the_email_flag => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  User.find(:all, :conditions => ["email = 'dado.t7@hotmail.com'"]).each do |user|
    puts user.name
    
    user.teammate_notification = false
    user.message_notification = false
    user.blog_comment_notification = false
    user.forum_comment_notification = false
    user.save!

  end
end