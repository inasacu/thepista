class Stage < ActiveRecord::Base

  # validations 
  validates_presence_of         :name
  validates_length_of           :name,                 :within => NAME_RANGE_LENGTH
  validates_format_of           :name,                 :with => /^[A-z 0-9 _.-]*$/
  validates_numericality_of     :home_ranking,         :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8
  validates_numericality_of     :away_ranking,         :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8
  
  validates_presence_of         :home_stage_name
  validates_length_of           :home_stage_name,                 :is => 1
  # validates_format_of           :home_stage_name,                 :with => /^[-A-Z]+$/
  validates_presence_of         :away_stage_name
  validates_length_of           :away_stage_name,                 :is => 1
  # validates_format_of           :away_stage_name,                 :with => /^[-A-Z]+$/
  
  belongs_to                    :cup

  # variables to access
  attr_accessible :name, :cup_id, :home_stage_name, :home_ranking, :away_stage_name, :away_ranking

  
end
