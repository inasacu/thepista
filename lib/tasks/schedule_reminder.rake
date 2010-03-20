# to run:    sudo rake the_reminder

desc "set reminder dates to schedules 3 days before"
task :the_reminder => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # get latest activity before migration
  max_activity = Activity.find(:first, :conditions => "id = (select max(id) from activities)")
  puts "max activity: (#{max_activity.id}) #{max_activity.item_type} - #{max_activity.item_id}"

  schedules = Schedule.find(:all, :conditions => ["starts_at >= ?", Time.zone.now - 210.days])
  schedules.each do |schedule|        
    puts "#{schedule.concept} set reminder"
    schedule.reminder_at = schedule.starts_at - 3.days
    schedule.reminder = true
    schedule.save!    
  end
  
  # remove all generated activities
  Activity.find(:all, :conditions => ["id > ?", max_activity.id]).each do |activity|
    puts "removed activity: (#{activity.id}) #{activity.item_type} - #{activity.item_id}"
    activity.destroy
  end
end

