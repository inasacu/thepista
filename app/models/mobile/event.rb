class Mobile::Event
  
  attr_accessor :name, :start_date, :parsed_start_date, :group_name, :group_id
  
  def initialize(schedule)
      @name = schedule.name
      @start_date = schedule.starts_at
      @parsed_start_date = schedule.starts_at
      @group_id = schedule.group.id
      @group_name = schedule.group.name
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