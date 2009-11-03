class Comment < ActiveRecord::Base

  include ActivityLogger

  belongs_to  :entry,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true
  belongs_to  :group,   :counter_cache => true

  validates_presence_of   :body
  validates_length_of     :body,            :within => BODY_RANGE_LENGTH

  before_create   :format_body
  after_create    :log_activity, :send_message_blog
  
  # method section
  def self.get_latest_comments(entry)
    find(:all, :conditions => ["entry_id = ? and created_at > ?",  entry.id, TIME_AGO_FOR_MOSTLY_ACTIVE], :order => 'created_at DESC')
  end
  
  # record if group does not exist
  def self.create_group_comment(group, blog, entry) 
    self.create!(:group_id => group.id, :entry_id => entry.id, :body => '.....') if self.group_exists?(group)
  end 

  # record if user does not exist
  def self.create_user_comment(user, blog, entry)  
    self.create!(:user_id => user.id, :entry_id => entry.id, :body => '.....') if self.user_exists?(user)
  end

  # Return true if the group does not exist
  def self.group_exists?(group)
    # find_by_group_id(group).nil?
    true
  end

  # Return true if the user does not exist
  def self.user_exists?(user)
    # find_by_user_id(user).nil?
    true
  end

  private
  
  def format_body
    self.body.gsub!(/\r?\n/, "<br>")
  end
  
  def log_activity
    add_activities(:item => self, :user => self.user) unless (self.user.nil?)
  end
  
  def send_message_blog()
    if self.group_id.blank?
      @send_mail ||= self.user.blog_comment_notification?
      UserMailer.deliver_message_blog(self.entry.blog.user, self.user, self) if @send_mail 
    end
  end
  
end