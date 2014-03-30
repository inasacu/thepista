class Mobile::EventM
  
  attr_accessor :legacy_id, :name, :start_date, :parsed_start_date, :group, 
  :fee, :player_limit, :week_day, :month_day, :month, :year, :place, :people_info
  
  def initialize(schedule)
    if !schedule.nil?
      @legacy_id = schedule.id
      @name = schedule.name
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
          new_event.player_limit = the_group.player_limit
          new_event.fee_per_game = 1
          new_event.fee_per_pista = 1
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

  def self.get_info_related_to_user(event_id=nil, user_id=nil)
    if event_id and user_id
      event_info = nil
      begin
        Schedule.transaction do
          the_schedule = Schedule.find(event_id)
          the_event = Mobile::EventM.new(the_schedule)
          the_user = User.find(user_id)
          user_status = Match.get_user_match_data(event_id, user_id)

          user_data = Hash.new
          user_data[:user_id] = the_user.id
          user_data[:is_member] = the_user.has_role?(:member,  the_schedule)
          user_data[:is_manager] = the_user.has_role?(:manager,  the_schedule)
          user_data[:is_creator] = the_user.has_role?(:creator,  the_schedule)
          user_data[:event_status] = user_status

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

  def self.change_user_team(user_id, event_id)
    result = nil
    begin
      
    rescue Exception => e
      Rails.logger.error("Exception while trying to change users team in event #{e.message}")
      Rails.logger.error("#{e.backtrace}")
      event_list = nil
    end
    return result
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
  
end