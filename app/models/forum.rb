class Forum < ActiveRecord::Base

  acts_as_commentable

  belongs_to    :schedule
  belongs_to    :meet
  belongs_to    :item,          :polymorphic => true

  validates_presence_of   :name 
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show", "petition"]
  
  # method section
  # record if schedule does not exist
  def self.create_schedule_forum(schedule) 
    self.create!(:schedule_id => schedule.id, :name => schedule.concept, :description => schedule.description) if self.schedule_exists?(schedule)
  end 
  
  # Return true if the schedule nil
  def self.schedule_exists?(schedule)
    find_by_schedule_id(schedule).nil?
  end
  
  # method section
  def self.find_item(item)
    find_by_item_id_and_item_type(item.id, item.class.to_s)
  end
  
  # record if group does not exist
  def self.create_item_blog(item) 
    self.create!(:item_id => item.id, :item_type => item.class.to_s, :name => item.name, :description => item.description) if self.item_exists?(item)
  end

  # Return true if the item nil
  def self.item_exists?(item)
    find_by_item_id_and_item_type(item, item.class.to_s).nil?
  end
  
end
