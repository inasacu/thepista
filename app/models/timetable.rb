class Timetable < ActiveRecord::Base
  belongs_to    :installation
  belongs_to    :type 
  
  validates_presence_of     :installation_id
  validates_presence_of     :type_id
  validates_presence_of     :starts_at
  validates_presence_of     :ends_at
  validates_presence_of     :timeframe
  
  # validates_uniqueness_of   :installation_id, :type_id, :starts_at, :ends_at, :timeframe

  # variables to access
  attr_accessible :installation_id, :type_id, :starts_at, :ends_at, :timeframe
  
  def day_of_week
    I18n.t(self.type.name.capitalize)
  end
  
  def self.installation_timetable(installation)
    find(:all, :conditions => ["installation_id = ?", installation], :order => "type_id, starts_at")
  end
  
  def self.installation_week_day(installation, current_day, is_holiday=false)
    the_day_of_week = 'Holiday'
    the_day_of_week = Date::DAYNAMES[current_day.wday] unless is_holiday
    
    find(:all, :select => "timetables.starts_at, timetables.ends_at, timetables.timeframe",
				:joins => "join types on types.id = timetables.type_id", 
				:conditions => ["timetables.archive = false and installation_id = ? and types.table_type = 'Timetable' and types.name =  ?", installation.id, the_day_of_week],
					:order => "timetables.type_id, timetables.starts_at")
	end			
  
end
