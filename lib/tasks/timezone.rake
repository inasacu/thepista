# to run:    sudo rake eltimezone

desc "update all timezone for users, groups, schedules"
task :eltimezone => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  users = (User.find :all, :conditions => ['archive = false']).collect {|user| user unless user.email.blank? }.compact
  users.each do |user|
    user.time_zone = 'Madrid'
    user.save!
    puts "#{user.name } #{user.time_zone}..."
  end

  groups = Group.find :all
  groups.each do |group|
    group.time_zone = 'Madrid'
    group.save!
    puts "#{group.name } #{group.time_zone}..."
  end

  schedules = Schedule.find :all
  schedules.each do |schedule|
    schedule.time_zone = 'Madrid'
    schedule.save!
    puts "#{schedule.concept } #{schedule.time_zone}..."
  end
end

