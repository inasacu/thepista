class Blog < ActiveRecord::Base
  
  acts_as_commentable

  belongs_to    :user
  belongs_to    :group
  belongs_to    :tournament
  belongs_to    :item,          :polymorphic => true

  validates_presence_of   :name, :description 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH

  # method section
  def self.find_item(item)
    find_by_item_id_and_item_type(item.id, item.class.to_s)
  end
  
  # record if group does not exist
  def self.create_item_blog(item) 
    self.create!(:item_id => item.id, :item_type => item.class.to_s, :name => item.name, :description => item.description) if self.item_exists?(item)
  end
  
  def self.create_group_blog(group) 
    self.create!(:group_id => group.id, :name => group.name, :description => group.description) if self.group_exists?(group)
  end 

  # record if user does not exist
  def self.create_user_blog(user) 
    self.create!(:user_id => user.id, :name => user.name, :description => user.name) if self.user_exists?(user)
  end

  # record if tournament does not exist
  def self.create_tournament_blog(tournament) 
    self.create!(:tournament_id => tournament.id, :name => tournament.name, :description => tournament.description) if self.tournament_exists?(tournament)
  end
  
  # Return true if the tournament nil
  def self.tournament_exists?(tournament)
    find_by_tournament_id(tournament).nil?
  end

  # Return true if the item nil
  def self.item_exists?(item)
    find_by_item_id_and_item_type(item, item.class.to_s).nil?
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
