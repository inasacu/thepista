class Round < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  validates_presence_of     :name
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
  validates_presence_of     :tournament_id  
  validates_numericality_of :phase,           :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  # variables to access
  attr_accessible :name, :tournament_id, :phase

  belongs_to    :tournament
  has_many      :meets
  has_many      :standings,     :conditions => "archive = false", :order => "ranking"
  
  def games_played
    games_played = 0
    self.meets.each {|meet| games_played += 1 if meet.played}
    return games_played
  end
end