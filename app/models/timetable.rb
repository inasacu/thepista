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

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
  :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]
  
  def day_of_week
    I18n.t(self.type.name.capitalize)
  end
  
  def self.installation_timetable(installation)
    find(:all, :conditions => ["installation_id = ?", installation], :order => "type_id, starts_at")
  end
  
end
