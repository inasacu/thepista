class Comment < ActiveRecord::Base
  belongs_to  :entry,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true
  belongs_to  :group,   :counter_cache => true

  validates_presence_of   :body
  validates_length_of     :body,            :within => BODY_RANGE_LENGTH
  
  # method section
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
end
