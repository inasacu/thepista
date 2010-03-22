# to run:    sudo rake the_abc

desc "the abc of  dates to schedules 3 days before"
task :the_abc => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # players that were in the roster to comment on the game
  # send email so that manager updates the scorecard w/ goals, baskets, etc...
  # players that have played 1/10th of the games
  # how many invitations to friends have been sent by user...get going...

  # send player that were in the game a reminder to comment what the best of the game was
  # send a link to rate the game from 1 to 5
  # who scored the goals
  # who was the best player

  schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ?", Time.zone.now, Time.zone.now + 1.day])
  schedules.each do |schedule|

    puts schedule.concept

    scorecard = schedule.group.scorecards.first
    manager_id = RolesUsers.find_team_manager(schedule.group).user_id

    schedule.the_roster.each do |match|
      puts "#{match.user.name} has played and the score was #{match.group_score} - #{match.invite_score}"

      message = Message.new
      message.subject = "#{I18n.t(:reminder_wall_message)}:  #{schedule.concept}"
      message.body = "#{I18n.t(:reminder_after_game_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
      message.item = schedule
      message.sender_id = manager_id
      message.recipient_id = match.user_id
      message.sender_read_at = Time.zone.now
      message.recipient_read_at = Time.zone.now
      message.sender_deleted_at = Time.zone.now
      message.recipient_deleted_at = Time.zone.now        
      message.save! if match.user_id == 2001

    end

    schedule.group.users.each do |user|
      puts "#{schedule.group.name} - #{user.name} #{scorecard.played.to_i}"

      message = Message.new
      message.subject = "#{I18n.t(:scorecard_latest)}:  #{schedule.group.name}"
      message.body = "#{I18n.t(:scorecard_latest)}  #{schedule.group.name}  #{I18n.t(:reminder_at_salute)}"
      message.item = scorecard
      message.sender_id = manager_id
      message.recipient_id = user.id
      message.sender_read_at = Time.zone.now
      message.recipient_read_at = Time.zone.now
      message.sender_deleted_at = Time.zone.now
      message.recipient_deleted_at = Time.zone.now        
      message.save! if user.id == 2001

    end

  end


  schedules = Schedule.find(:all, 
  :conditions => ["played = false and send_reminder_at is null and reminder = true and reminder_at >= ? and reminder_at <= ?", Time.zone.now, Time.zone.now + 1.day])
  schedules.each do |schedule|
    puts "#{schedule.concept} - #{schedule.starts_at} - #{schedule.ends_at} - #{schedule.reminder_at} "

    total_schedules = Schedule.count(:conditions => ["group_id = ?", schedule.group])
    one_third = total_schedules.to_f / 5

    manager_id = RolesUsers.find_team_manager(schedule.group).user_id

    schedule.group.users.each do |user|
      scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user, schedule.group])

      # send email to user and request to have a email sent
      if scorecard.played.to_i >= one_third.round and user.message_notification?

        puts "#{schedule.group.name} - #{user.name} #{scorecard.played.to_i} #{one_third.round}"  

        message = Message.new
        message.subject = "#{I18n.t(:reminder_at)}:  #{schedule.concept}"
        message.body = "#{I18n.t(:reminder_at_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
        message.item = schedule
        message.sender_id = manager_id
        message.recipient_id = user.id
        message.sender_read_at = Time.zone.now
        message.recipient_read_at = Time.zone.now
        message.sender_deleted_at = Time.zone.now
        message.recipient_deleted_at = Time.zone.now 
        message.save! if user.id == 2001

      end      
    end   

    schedule.send_reminder_at = Time.zone.now
    schedule.save!

  end

  schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ? and send_result_at is null", Time.zone.now, Time.zone.now + 1.day])
  schedules.each do |schedule|
    puts "#{schedule.concept} - #{schedule.starts_at} resultados missing... "

    match = Match.find(:first, :conditions => ["type_id = 1 and schedule_id = ? and (group_score is null or invite_score is null)", schedule])
    manager_id = RolesUsers.find_team_manager(schedule.group).user_id
    manager = User.find(manager_id)

    # send email to user and request to have a email sent
    if !match.nil?  and manager.message_notification?   

      puts "results missing"  

      message = Message.new
      message.subject = "#{I18n.t(:update_match)}:  #{schedule.concept}"
      message.body = "#{I18n.t(:update_match_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
      message.item = match
      message.sender_id = manager_id
      message.recipient_id = 2001
      message.sender_read_at = Time.zone.now
      message.recipient_read_at = Time.zone.now
      message.sender_deleted_at = Time.zone.now
      message.recipient_deleted_at = Time.zone.now    
      message.save! 

    end  

    schedule.send_result_at = Time.zone.now
    schedule.save!   
  end

end

