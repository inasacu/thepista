# TABLE "holidays"
# t.string   "name"
# t.integer  "venue_id"
# t.datetime "starts_at"
# t.datetime "s_at"
# t.boolean  "holiday_hour" 
# t.boolean  "archive"      
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "type_id"

# insert into holidays (name, venue_id, starts_at, ends_at, holiday_hour) values('15 de Agosto', 1, '2012/08/14 22:00:00', '2012/08/15 21:59:59', true)


class Holiday < ActiveRecord::Base
  belongs_to    :venue 
  belongs_to    :type

  # variables to access
  attr_accessible :venue_id, :type_id, :name, :starts_at, :ends_at, :holiday_hour, :archive

  def self.holiday_week_day(venue, starts_at, ends_at)
    find(:all, :joins => "JOIN venues on venues.id = holidays.venue_id",
               :conditions => ["venues.id = ? and holidays.archive = false and holidays.starts_at >= ? and holidays.ends_at < ?", venue, starts_at, ends_at], 
               :order => 'holidays.starts_at')
  end			
  
  def self.holiday_available(venue, holiday)
      find(:first, :conditions =>["venue_id = ? and starts_at = ? and ends_at = ?", venue, holiday.starts_at, holiday.ends_at])
  end  

end
