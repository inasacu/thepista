class Holiday < ActiveRecord::Base
  belongs_to    :venue 

  # variables to access
  attr_accessible :venue_id, :name, :starts_at, :ends_at, :holiday_hour, :archive

  def self.holiday_week_day(venue, starts_at, ends_at)
    find(:all, :joins => "JOIN venues on venues.id = holidays.venue_id",
               :conditions => ["venues.id = ? and holidays.archive = false and holidays.starts_at >= ? and holidays.ends_at < ?", venue, starts_at, ends_at], 
               :order => 'holidays.starts_at')
  end			
  
  def self.holiday_available(venue, holiday)
      find(:first, :conditions =>["venue_id = ? and starts_at = ? and ends_at = ?", venue, holiday.starts_at, holiday.ends_at])
  end  

end
