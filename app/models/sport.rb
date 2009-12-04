class Sport < ActiveRecord::Base

  has_many :groups
  has_many :markers
  has_many :tournamentes

  # validations 
  validates_uniqueness_of   :name,    :case_sensitive => false
  
  validates_presence_of     :name
  validates_presence_of     :description
  
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
      
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
    
  validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  # variables to access
  attr_accessible :name, :points_for_win, :points_for_draw, :points_for_lose
  attr_accessible :description, :icon
  
  def self.sport_name
    find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
  end  
end