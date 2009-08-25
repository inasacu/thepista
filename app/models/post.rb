class Post < ActiveRecord::Base
  belongs_to  :topic,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true

  validates_presence_of   :body
  validates_length_of     :body,            :within => BODY_RANGE_LENGTH
  
  # method section
  # record if schedule does not exist
  def self.create_schedule_post(forum, topic, user) 
    self.create!(:topic_id => topic.id, :user_id => user.id, :body => forum.description) if self.topic_exists?(topic)
  end 

  # Return true if the schedule does not exist
  def self.topic_exists?(topic)
    # find_by_topic_id(topic).nil?
    true
  end
end