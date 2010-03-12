# to run:    sudo rake looking_for

desc "all teams and players as looking for players and teams"
task :looking_for => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  groups = Group.find(:all)
  groups.each do |group|    
    puts "#{group.name} set to NOT looking for players"
    group.looking_for_user = false
    group.save!
  end

  users = User.find(:all)
  users.each do |user|
    # puts "#{user.name} set to NOT looking for team"
    user.looking_for_group = false
    user.save!    
  end
  
  users = User.find(:all, :conditions => "archive = false and current_login_at is not null")
  users.each do |user|
    puts "#{user.name} set to LOOKING for team"
    user.looking_for_group = true
    user.save!    
  end
  
end

