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
  
  # schedules = Schedule.find(:all, :conditions => ["played = false and sent_reminder_at is null and reminder = true and reminder_at >= ? and reminder_at <= ?", LAST_24_HOURS, NEXT_24_HOURS])
  # schedules.each do |schedule|
  #   puts "#{schedule.concept} - #{schedule.starts_at} - #{schedule.ends_at} - #{schedule.reminder_at} "
  #   
  #   total_schedules = Schedule.count(:conditions => ["group_id = ?", schedule.group])
  #   one_third = total_schedules.to_f / 5
  #   
  #   manager_id = RolesUsers.find_team_manager(schedule.group).user_id
  #   
  #   schedule.group.users.each do |user|
  #     scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user, schedule.group])
  #     
  #     # send email to user and request to have a email sent
  #     if scorecard.played.to_i >= one_third.round and user.message_notification?   
  #       
  #       puts "#{schedule.group.name} - #{user.name} #{scorecard.played.to_i} #{one_third.round}"  
  #       
  #       message = Message.new
  #       message.subject = "#{I18n.t(:reminder_at)}:  #{schedule.concept}"
  #       message.body = "#{I18n.t(:reminder_at_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
  #       message.item = schedule
  #       message.sender_id = manager_id
  #       message.recipient_id = user.id
  #       message.sender_read_at = Time.zone.now
  #       message.recipient_read_at = Time.zone.now
  #       message.sender_deleted_at = Time.zone.now
  #       message.sender_deleted_at = Time.zone.now        
  #       message.save!
  #       
  #     end      
  #   end   
  # 
  #   schedule.send_reminder_at = Time.zone.now
  #   schedule.save!
  #   
  # end
  
  # schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ? and send_result_at is null", LAST_24_HOURS, TWO_DAYS_AFTER])
  # # schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and send_result_at is null", Time.zone.now])
  # schedules.each do |schedule|
  #   puts "#{schedule.concept} - #{schedule.starts_at} resultados missing... "
  # 
  #   match = Match.find(:first, :conditions => ["type_id = 1 and schedule_id = ? and (group_score is null or invite_score is null)", schedule])
  #   manager_id = RolesUsers.find_team_manager(schedule.group).user_id
  #   manager = User.find(manager_id)
  # 
  #   # send email to user and request to have a email sent
  #   if !match.nil?  and manager.message_notification?   
  # 
  #     puts "results missing"  
  # 
  #     message = Message.new
  #     message.subject = "#{I18n.t(:update_match)}:  #{schedule.concept}"
  #     message.body = "#{I18n.t(:update_match_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
  #     message.item = match
  #     message.sender_id = manager_id
  #     message.recipient_id = manager_id
  #     message.sender_read_at = Time.zone.now
  #     message.recipient_read_at = Time.zone.now
  #     message.sender_deleted_at = Time.zone.now
  #     message.sender_deleted_at = Time.zone.now        
  #     message.save!
  # 
  #   end  
  # 
  #   schedule.send_result_at = Time.zone.now
  #   schedule.save!   
  # end
  
  
  # remove all generated activities
  Activity.find(:all, :conditions => ["id > ?", max_activity.id]).each do |activity|
    puts "removed activity: (#{activity.id}) #{activity.item_type} - #{activity.item_id}"
    activity.destroy
  end
end

