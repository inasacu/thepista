class Round < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  # validations 
  # validates_uniqueness_of   :name,    :case_sensitive => false

  validates_presence_of     :name
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
  validates_presence_of     :tournament_id  
  validates_numericality_of :jornada,         :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  # validates_presence_of     :description
  # validates_presence_of     :conditions
  # validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
  # validates_length_of       :conditions,      :within => DESCRIPTION_RANGE_LENGTH

  # variables to access
  attr_accessible :name, :tournament_id, :jornada
  attr_accessible :description, :conditions

  belongs_to    :tournament
  has_many      :meets

  before_create :format_description, :format_conditions
  before_update :format_description, :format_conditions

  # # method section
  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end
end