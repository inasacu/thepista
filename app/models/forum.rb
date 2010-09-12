class Forum < ActiveRecord::Base

  acts_as_commentable

  belongs_to    :schedule
  belongs_to    :meet

  validates_presence_of   :name 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH

  # method section
  # record if schedule does not exist
  def self.create_schedule_forum(schedule) 
    self.create!(:schedule_id => schedule.id, :name => schedule.concept, :description => schedule.description) if self.schedule_exists?(schedule)
  end 
  
  # Return true if the schedule nil
  def self.schedule_exists?(schedule)
    find_by_schedule_id(schedule).nil?
  end
end
