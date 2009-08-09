class Blog < ActiveRecord::Base

  has_many      :entries,      :dependent => :delete_all
  has_many      :comments,     :through => :entries

  belongs_to    :user
  belongs_to    :group

  validates_presence_of   :name, :description 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH

  # method section
  # record if group does not exist
  def self.create_group_blog(group) 
    self.create!(:group_id => group.id) if self.group_exists?(group)
  end 

  # record if user does not exist
  def self.create_user_blog(user) 
    self.create!(:user_id => user.id, :name => '.....', :description => '.....') if self.user_exists?(user)
  end

  # Return true if the group does not exist
  def self.group_exists?(group)
    find_by_group_id(group).nil?
  end

  # Return true if the user does not exist
  def self.user_exists?(user)
    find_by_user_id(user).nil?
  end
end
