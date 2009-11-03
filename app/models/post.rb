class Post < ActiveRecord::Base

  include ActivityLogger

  belongs_to  :topic,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true

  # validations  
  validates_presence_of         :body
  validates_length_of           :body,                         :within => BODY_RANGE_LENGTH

  before_create :format_body
  after_create  :log_activity

  # method section
  # record if schedule does not exist
  def self.create_schedule_post(forum, topic, user, description) 
    self.create!(:topic_id => topic.id, :user_id => user.id, :body => description) if self.topic_exists?(topic)
  end 

  # Return true if the schedule does not exist
  def self.topic_exists?(topic)
    # find_by_topic_id(topic).nil?
    true
  end

  private
  
  def format_body
    self.body.gsub!(/\r?\n/, "<br>")
  end
  
  def log_activity
    add_activities(:item => self, :user => self.user, :include_user => false)
  end
end