class Blog < ActiveRecord::Base

  has_many      :entries,      :dependent => :delete_all
  has_many      :comments,     :through => :entries

  belongs_to    :user
  belongs_to    :group
  belongs_to    :tournament

  validates_presence_of   :name, :description 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH

  # method section
  # record if group does not exist
  def self.create_group_blog(group) 
    self.create!(:group_id => group.id, :name => '.....', :description => '.....') if self.group_exists?(group)
  end 

  # record if user does not exist
  def self.create_user_blog(user) 
    self.create!(:user_id => user.id, :name => '.....', :description => '.....') if self.user_exists?(user)
  end

  # record if tournament does not exist
  def self.create_tournament_blog(tournament) 
    self.create!(:tournament_id => tournament.id, :name => '.....', :description => '.....') if self.tournament_exists?(tournament)
  end
  
  # Return true if the tournament nil
  def self.tournament_exists?(tournament)
    find_by_tournament_id(tournament).nil?
  end

  # Return true if the group nil
  def self.group_exists?(group)
    find_by_group_id(group).nil?
  end

  # Return true if the user nil
  def self.user_exists?(user)
    find_by_user_id(user).nil?
  end
end
