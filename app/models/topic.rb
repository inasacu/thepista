class Topic < ActiveRecord::Base
  has_many    :posts,   :dependent => :delete_all

  belongs_to  :forum,   :counter_cache => true
  belongs_to  :user

  validates_presence_of   :name
  validates_length_of     :name,            :within => NAME_RANGE_LENGTH

  # method section
  # record if schedule does not exist
  def self.create_schedule_topic(forum, user) 
    self.create!(:forum_id => forum.id, :user_id => user.id, :name => forum.name) if self.forum_exists?(forum)
  end 

  # Return true if the schedule does not exist
  def self.forum_exists?(forum)
    find_by_forum_id(forum).nil?
  end
end