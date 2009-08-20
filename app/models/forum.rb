class Forum < ActiveRecord::Base
  has_many      :topics,    :dependent => :delete_all
  has_many      :posts,     :through => :topics

  belongs_to    :schedule

  validates_presence_of   :name, :description 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH

  # method section
  # record if schedule does not exist
  def self.create_schedule_forum(schedule) 
    self.create!(:schedule_id => schedule.id, :name => '.....', :description => '.....') if self.schedule_exists?(schedule)
  end 

  # Return true if the schedule nil
  def self.schedule_exists?(schedule)
    find_by_schedule_id(schedule).nil?
  end

end
