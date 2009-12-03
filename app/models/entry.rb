class Entry < ActiveRecord::Base
  
  has_many    :comments,   :dependent => :delete_all
  
  belongs_to  :blog,   :counter_cache => true
  belongs_to  :user
  belongs_to  :group
  belongs_to  :tournament

  validates_presence_of   :title, :body
  validates_length_of     :title,           :within => TITLE_RANGE_LENGTH
  validates_length_of     :body,            :within => BODY_RANGE_LENGTH

  # method section
  # record if group does not exist
  def self.create_group_entry(group, blog) 
    self.create!(:group_id => group.id, :blog_id => blog.id, :title => '.....', :body => '.....') #if self.group_exists?(group)
  end 

  # record if user does not exist
  def self.create_user_entry(user, blog) 
    self.create!(:user_id => user.id, :blog_id => blog.id, :title => '.....', :body => '.....') #if self.user_exists?(user)
  end

  # record if tournament does not exist
  def self.create_tournament_entry(tournament, blog) 
    self.create!(:tournament_id => tournament.id, :blog_id => blog.id, :title => '.....', :body => '.....') #if self.group_exists?(tournament)
  end
  
  # Return true if the group does not exist
  # def self.group_exists?(group)
  #   find_by_group_id(group).nil?
  # end

  # Return true if the user does not exist
  # def self.user_exists?(user)
  #   find_by_user_id(user).nil?
  # end
end