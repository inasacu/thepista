# to run:    sudo rake looking_for

desc "all teams and players as looking for players and teams"
task :looking_for => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  groups = Group.find(:all)
  groups.each do |group|    
    puts "#{group.name} NOT NOT" if group.archive
    puts "#{group.name} LOOKING for players" unless group.archive
    group.looking = !group.archive
    group.save!
  end

  users = User.find(:all)
  users.each do |user|
    puts "#{user.name} NOT NOT" if user.archive
    puts "#{user.name} LOOKING for team" unless user.archive 
    user.looking = !user.archive
    user.save!    
  end
  
end

