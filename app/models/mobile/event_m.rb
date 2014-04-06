class Mobile::EventM
  
  attr_accessor :legacy_id, :name, :start_date, :start_datetime_millis, :end_datetime_millis,
  :parsed_start_date, :group, :fee, :player_limit, :week_day, :month_day, :month, :year, :place, :people_info
  
  def initialize(schedule)
    if !schedule.nil?
      @legacy_id = schedule.id
      @name = schedule.name
      # this is multiplied by 1000 for JS code to calculate properly the date and times
      # in ruby code probably is better to multiply it by 1.000 to be calculated then with Time.at(millis)
      @start_datetime_millis = schedule.starts_at.to_i * 1000
      @end_datetime_millis = schedule.ends_at.to_i * 1000
      @start_date = schedule.starts_at.strftime "%d/%m/%Y"
      @start_time = schedule.starts_at.strftime "%H:%M"
      @end_date = schedule.ends_at.strftime "%d/%m/%Y"
      @end_time = schedule.ends_at.strftime "%H:%M"
      #@parsed_start_date = schedule.starts_at.strftime "%d/%m/%Y- %H:%M" 

      @group = {:id => schedule.group.id, :name => schedule.group.name}
      @fee = schedule.fee_per_game

      @people_info = {:comming => schedule.convocados.count, 
      :missing => schedule.no_shows.count, :last_minute => schedule.last_minute.count}
      
      marker = schedule.marker
      if marker
        @place = {:name => marker.name, :location => {:latitude => marker.latitude, :longitude => marker.longitude}}
      else
        @place = {:name => "No asignado"}
      end
      
      @player_limit = schedule.player_limit
      @player_limit = schedule.player_limit
      @week_day = schedule.starts_at.wday
      @month_day = schedule.starts_at.mday
      @month = schedule.starts_at.month
      @year = schedule.starts_at.year
      #t.strftime "%Y-%m-%d %H:%M:%S %z"  
    end
  end
  
  def self.build_from_schedules(schedule_list)
    events_list = []
    if schedule_list
      schedule_list.each do |s|
        events_list << self.new(s)
      end
    end
    return events_list
  end

  # MOBILE
  
  def self.user_active_events(user_id)
    begin
      my_schedules = Schedule.joins("join matches on matches.schedule_id = schedules.id")
                  .where("matches.user_id=? and matches.type_id in (?,?) and schedules.starts_at >= ?", 
                  user_id, TYPE_CONVOCADO, TYPE_ULTIMAHORA, Time.zone.now)
                  .order("schedules.starts_at ASC")
      my_events = Mobile::EventM.build_from_schedules(my_schedules)
    rescue Exception => exc
      Rails.logger.error("Exception while getting user active events #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      my_events = nil  
    end
    return my_events
  end
  
  def self.active_user_groups_events(user_id)
    events_list = nil
    begin
      user = User.find(user_id)
      my_groups = user.groups
      events_list = Array.new

      my_groups.each do |group|
        active_schedules = Mobile::GroupM.active_schedules(group)
        active_events = Mobile::EventM.build_from_schedules(active_schedules)
        events_list += active_events     
      end
    rescue Exception => exc
      Rails.logger.error("Exception while getting user groups events #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      events_list = nil
    end
    
    return  events_list
  end
  
  def self.get_by_id(event_id)
    begin
      schedule = Schedule.find(event_id)
      event = Mobile::EventM.new(schedule)
    rescue Exception => exc
      Rails.logger.error("Exception while getting event by id #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      event = nil  
    end
    return event
  end

  def self.create_new(event_map=nil)
    if event_map
      new_event = Schedule.new
      begin
        new_event_mobile = nil
        Schedule.transaction do

          the_group = Group.find(event_map[:event_group])
          the_user = User.find(event_map[:user_id])

          # gets start_date from milliseconds     
          start_date = Time.at( event_map[:event_date].to_i / 1000 )
          start_time = Time.at( event_map[:event_time].to_i / 1000 )
          start_datetime = Time.new(start_date.year,start_date.month,start_date.mday,start_time.hour,start_time.min,start_time.sec) 

          end_datetime = start_datetime + 1.hour
          
          new_event.name = event_map[:event_name]
          new_event.jornada = 1
          #new_event.starts_at_date = start_datetime
          new_event.starts_at = start_datetime
          #new_event.ends_at_date = end_datetime
          new_event.ends_at = end_datetime
          new_event.reminder_at = new_event.starts_at - 2.days  
          new_event.available = (new_event.starts_at > Time.zone.now + MINUTES_TO_RESERVATION )
          new_event.item_id = the_group.id
          new_event.item_type = the_group.class.to_s
          new_event.group_name = the_group.name
          new_event.group_id = the_group.id
          new_event.sport_id = the_group.sport_id
          new_event.marker_id = the_group.marker_id
          new_event.time_zone = the_group.time_zone
          #new_event.player_limit = the_group.player_limit
          new_event.player_limit = event_map[:event_player_limit]
          new_event.fee_per_game = event_map[:event_fee] ? event_map[:event_fee] : 1
          new_event.fee_per_pista = event_map[:event_fee] ? event_map[:event_fee] : 1
          new_event.fee_per_pista = the_group.player_limit * new_event.fee_per_game if the_group.player_limit > 0
          new_event.season = Time.zone.now.year

          # save event with exception if not
          new_event.save!

          # add the roles to creator user
          new_event.create_schedule_roles(the_user)

          # the user is added to the event - add record into matches
          Match.create_item_schedule_match(new_event, the_user)

          # build from just created schedule-event
          new_event_mobile = Mobile::EventM.new(new_event)

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while creating event #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        new_event_mobile = nil
      end

      return new_event_mobile
    else
      Rails.logger.debug "Null map for the event info"
      return nil
    end
  end

  def self.edit(event_map=nil)
    if event_map
      begin
        edited_event = Schedule.find(event_map[:event_id])
        edited_event_mobile = nil
        Schedule.transaction do

          the_group = Group.find(event_map[:event_group])
          the_user = User.find(event_map[:user_id])

          # gets start_date from milliseconds     
          start_date = Time.at( event_map[:event_date].to_i / 1000 )
          start_time = Time.at( event_map[:event_time].to_i / 1000 )
          start_datetime = Time.new(start_date.year,start_date.month,start_date.mday,start_time.hour,start_time.min,start_time.sec) 

          end_datetime = start_datetime + 1.hour
          
          edited_event.name = event_map[:event_name]
          edited_event.jornada = 1
          #edited_event.starts_at_date = start_datetime
          edited_event.starts_at = start_datetime
          #edited_event.ends_at_date = end_datetime
          edited_event.ends_at = end_datetime
          edited_event.reminder_at = edited_event.starts_at - 2.days  
          edited_event.available = (edited_event.starts_at > Time.zone.now + MINUTES_TO_RESERVATION )
          edited_event.sport_id = the_group.sport_id
          edited_event.marker_id = the_group.marker_id
          edited_event.time_zone = the_group.time_zone
          #edited_event.player_limit = the_group.player_limit
          edited_event.player_limit = event_map[:event_player_limit]
          edited_event.fee_per_game = event_map[:event_fee] ? event_map[:event_fee] : 1
          edited_event.fee_per_pista = event_map[:event_fee] ? event_map[:event_fee] : 1
          edited_event.fee_per_pista = the_group.player_limit * edited_event.fee_per_game if the_group.player_limit > 0
          edited_event.season = Time.zone.now.year

          # edit event with exception if not
          edited_event.save!

          # legacy code
          Match.create_schedule_match(edited_event) 
          if DISPLAY_FREMIUM_SERVICES  
            Fee.create_group_fees(edited_event) 
            Fee.create_user_fees(edited_event) 
          end
          # build from just created schedule-event
          edited_event_mobile = Mobile::EventM.new(edited_event)

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while editing event #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        edited_event_mobile = nil
      end

      return edited_event_mobile
    else
      Rails.logger.debug "Null map for the event info"
      return nil
    end
  end

  def self.get_info_related_to_user(event_id=nil, user_id=nil)
    if event_id and user_id
      event_info = nil
      begin
        Schedule.transaction do
          the_schedule = Schedule.find(event_id)
          the_event = Mobile::EventM.new(the_schedule)
          the_user = User.find(user_id)
          the_match = the_schedule.matches.where("user_id=?", user_id).first

          user_data = Hash.new
          user_data[:user_id] = the_user.id
          user_data[:is_member] = the_user.has_role?(:member,  the_schedule)
          user_data[:is_manager] = the_user.has_role?(:manager,  the_schedule)
          user_data[:is_creator] = the_user.has_role?(:creator,  the_schedule)
          user_data[:user_event_state] = the_match.type.id

          event_info = Hash.new
          event_info[:event] = the_event
          event_info[:user_data] = user_data

        end # end transaction
      rescue Exception => e
        Rails.logger.error("Exception while getting event info #{e.message}")
        Rails.logger.error("#{e.backtrace}")
        event_info = nil
      end

      return event_info
    else
      Rails.logger.debug "Null event id and user id"
      return nil
    end
  end

  def self.do_search(start_date=nil, start_time=nil, city=nil)
    event_list = nil
    begin
      event_list = Array.new()
      search_date = Time.now
      schedules = nil

      # SELECT a.* 
      # FROM schedules as a
      # join markers as b
      # on a.marker_id = b.id
      # and b.city='Madrid'
      # and a.starts_at>='2005-10-30 T 10:45 UTC'

      if search_date and city
        # Location and date search
        schedules = Schedules.joins("inner join markers on schedules.marker_id = markers.id")
                 .where("schedules.starts_at >= ? and markers.city=?", search_date, city)
      elsif city
        # Location search
        schedules = Schedules.joins("inner join markers on schedules.marker_id = markers.id")
                 .where("markers.city=?", city)
      elsif search_date
        # Date search
        schedules = Schedules.where("schedules.starts_at >= ?", search_date)
      end 
      
      event_list = Mobile::EventM.build_from_schedules(schedules)

    rescue Exception => e
      Rails.logger.error("Exception while searchinv for events #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      event_list = nil
    end

    return event_list
    
  end

  def self.last_user_events(user_id=nil, offset_factor=0)
    event_list = nil
    begin
      event_list = Array.new()
      my_schedules = Schedule.joins("join matches on matches.schedule_id = schedules.id")
                  .where("matches.user_id=?", user_id)
                  .order("schedules.starts_at ASC")
                  .limit(5).offset(5*offset_factor.to_i)
      event_list = Mobile::EventM.build_from_schedules(my_schedules)
    rescue Exception => e
      Rails.logger.error("Exception while getting historical of events #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      event_list = nil
    end
    return event_list
  end

  def self.post_user_message(user_id, event_id, message)
    result = nil
    begin
      
    rescue Exception => e
      Rails.logger.error("Exception while trying to users message forum for event #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      event_list = nil
    end
    return result
  end

  def self.change_user_match_state(schedule_id, user_id, newstate)
    <<-DOC
      1;"convocado"
      2;"ultima_hora"
      3;"ausente"
      4;"no_jugado"
      5;"Ultima_Hora"
    DOC
    begin
      Match.transaction do
          # get match
          match = Match.where("schedule_id=? and user_id=?", schedule_id, user_id).first
          
          # get user
          user = User.find(user_id)
          
          # 1 == player is in team one
          # x == game tied, doesnt matter where player is
          # 2 == player is in team two      
          @user_x_two = "1" if (match.group_id.to_i > 0 and match.invite_id.to_i == 0)
          @user_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
          @user_x_two = "2" if (match.group_id.to_i == 0 and match.invite_id.to_i > 0)


          # change treatment
          the_schedule = match.schedule

          unless user == match.user or 
                (user.is_manager_of?(the_schedule) or user.is_manager_of?(the_schedule.group))
            return
          end

          type = Type.find(newstate)
          played = (type.id == 1 and !match.group_score.nil? and !match.invite_score.nil?)

          player_limit = the_schedule.player_limit
          total_players = the_schedule.the_roster_count   
          has_player_limit = (total_players >= player_limit)
          send_last_minute_message = (has_player_limit and NEXT_48_HOURS > the_schedule.starts_at and the_schedule.send_reminder_at.nil?)

          if send_last_minute_message

            type_change = [[1,2,-1], [1,3,-1]] 
            type_change = [[1,2,-1], [1,3,-1], [2,1,1], [3,1,1]] if DISPLAY_FREMIUM_SERVICES
            send_last_minute_message = false

            type_change.each do |a, b, change|
              new_player_limit = total_players + change
              send_last_minute_message = (match.type_id == a and type.id == b and player_limit < new_player_limit) ? true : send_last_minute_message
            end

            if send_last_minute_message 
              the_schedule.last_minute_reminder 
              the_schedule.send_reminder_at = Time.zone.now
              the_schedule.save!
            end

          end

          if match.update_attributes(:type_id => type.id, 
                                    :played => played, 
                                    :user_x_two => @user_x_two, 
                                    :status_at => Time.zone.now)

            # delay instruction was removed because was throwing stack too deep error
            Scorecard.calculate_user_played_assigned_scorecard(match.user, the_schedule.group)

            if DISPLAY_FREMIUM_SERVICES
              # set fee type_id to same as match type_id
              the_fee = Fee.find(:all, 
              :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", match.user_id, match.schedule_id])
              the_fee.each {|fee| fee.type_id = type.id; fee.save!}
            end

          end

          # wraps the match into EventUserData
          user_event_data = Mobile::EventM.get_info_related_to_user(schedule_id, user_id)
          return user_event_data
          
      end
    rescue Exception => exc
      Rails.logger.error("Exception while changing user event state #{exc.message}")
      Rails.logger.error("#{exc.backtrace}")
      user_event_data = nil
      return user_event_data
    end
    
  end

  def self.get_teams(event_id=nil)
    teams_map = nil
    begin
      teams_map = Hash.new
      teams_map[:team1] = Array.new
      teams_map[:team2] = Array.new
      schedule = Schedule.find(event_id)

      schedule.matches.each do |m|
        user = m.user
        if m.group_id !=0
          teams_map[:team1] << Mobile::UserM.new(user)
        else
          teams_map[:team2] << Mobile::UserM.new(user)
        end
      end

    rescue Exception => e
      Rails.logger.error("Exception while getting event teams #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      teams_map = nil
    end
    return teams_map
  end

  def self.get_results(event_id=nil)
    results_map = nil
    begin
      results_map = Hash.new
      schedule = Schedule.find(event_id)

      reference_match = Match.where("schedule_id=?", event_id).first
      results_map[:local_score] = reference_match.group_score
      results_map[:visitor_score] = reference_match.invite_score
      results_map[:individual_score] = Array.new

      schedule.matches.each do |m|
        results_map[:individual_score] << {"#{m.user_id.to_s}" => m.goals_scored}
      end

    rescue Exception => e
      Rails.logger.error("Exception while getting event results #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      results_map = nil
    end
    return results_map
  end

  def self.update_score(event_id=nil, total_score=nil, individual_score=nil)
    begin
      success = false
      Schedule.transaction do

          # local and visitor score
          local_score = total_score[:local]
          visitor_score = total_score[:visitor]
          reference_match = Match.where("schedule_id=?", event_id).first
          schedule = reference_match.schedule
          
          if reference_match
            schedule.matches.each do |match|
              match.group_score = local_score
              match.invite_score = visitor_score
              match.played = (match.type_id == 1 and schedule.played) 

              # if the individual score of the user is available then is set
              if individual_score and individual_score["#{match.user_id.to_s}"]
                match.goals_scored = individual_score["#{match.user_id.to_s}"].to_i
              end 

              # 1 == team one wins
              # x == teams draw
              # 2 == team two wins
              match.one_x_two = "" if (local_score.nil? or visitor_score.nil?)
              match.one_x_two = "1" if (local_score.to_i > visitor_score.to_i)
              match.one_x_two = "X" if (local_score.to_i == visitor_score.to_i)
              match.one_x_two = "2" if (local_score.to_i < visitor_score.to_i)

              # 1 == player is in team one
              # x == game tied, doesnt matter where player is
              # 2 == player is in team two      
              match.user_x_two = "1" if (match.group_id.to_i > 0 and match.invite_id.to_i == 0)
              match.user_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
              match.user_x_two = "2" if (match.group_id.to_i == 0 and match.invite_id.to_i > 0)
              
              match.block_token = '' if schedule.played

              match.save!  
            end    

            schedule.played = (!local_score.nil? and !visitor_score.nil?)
            schedule.save!  

            Scorecard.delay.calculate_group_scorecard(schedule.group)
            Schedule.delay.send_after_scorecards 
            Match.set_default_user_to_ausente(reference_match)
          end

          success = true
      end

    rescue Exception => e
      Rails.logger.error("Exception while updating score results for event #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      success = false
    end
    return success
  end

  def self.change_user_team(user_id, event_id)
    result = nil
    begin
      
      Schedule.transaction do 
      
        result = Hash.new

        the_match = Match.where("user_id=? and schedule_id=?", user_id, event_id).first
        temp_invite = the_match.invite_id
        temp_group = the_match.group_id
        the_match.invite_id = temp_group
        the_match.group_id = temp_invite
        is_second_team = !(the_match.group_id > 0)

        the_match.save!
        Scorecard.calculate_user_played_assigned_scorecard(the_match.user, the_match.schedule.group)

        result[:success] = true
        result[:is_second_team] = is_second_team

        local_team = Array.new
        visitor_team = Array.new
        # obtain list of matches with information about user, event, and team
        result[:teams] = {:local => local_team, :visitor => visitor_team}

      end
      
    rescue Exception => e
      Rails.logger.error("Exception while trying to change users team in event #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      result = nil
    end
    return result
  end
  
end