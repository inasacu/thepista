class Mobile::Event
  
  attr_accessor :legacy_id, :name, :start_date, :parsed_start_date, :group_name, :group_id, 
  :fee, :player_limit, :week_day, :month_day, :month, :year
  
  def initialize(schedule)
    if !schedule.nil?
      @legacy_id = schedule.id
      @name = schedule.name
      @start_date = schedule.starts_at.strftime "%d/%m/%Y"
      @start_time = schedule.starts_at.strftime "%H:%M"
      @end_date = schedule.ends_at.strftime "%d/%m/%Y"
      @end_time = schedule.ends_at.strftime "%H:%M"
      #@parsed_start_date = schedule.starts_at.strftime "%d/%m/%Y- %H:%M"  
      @group_id = schedule.group.id
      @group_name = schedule.group.name
      @fee = schedule.fee_per_game
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
  
end