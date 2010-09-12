# to run:    sudo rake looking_for

desc "all teams and players as looking for players and teams"
task :looking_for => :environment do |t|

  # ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  # 
  # groups = Group.find(:all)
  # groups.each do |group|    
  #   puts "#{group.name} NOT NOT" if group.archive
  #   puts "#{group.name} LOOKING for players" unless group.archive
  #   group.looking = group.archive
  #   group.save!
  # end
  # 
  # groups = Group.find(:all, :conditions => ["id in (select distinct group_id from schedules where starts_at >= ?)", Time.zone.now - 90.days])
  # groups.each do |group|    
  #   puts "#{group.name} NOT NOT" if group.archive
  #   puts "#{group.name} LOOKING for players" unless group.archive
  #   group.looking = !group.archive
  #   group.save!
  # end
  # 
  # users = User.find(:all)
  # users.each do |user|
  #   puts "#{user.name} NOT NOT" if user.archive
  #   puts "#{user.name} LOOKING for team" unless user.archive 
  #   user.looking = !user.archive
  #   user.save!    
  # end
  
end

