class Activity < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :item,      :polymorphic => true
  has_many    :feeds,     :dependent => :destroy
  
  # Return a feed drawn from all activities.
  # The fancy SQL is to keep inactive users out of feeds.
  # It's hard to do that entirely, but this way deactivated users 
  # won't be the user in "<user> has <done something>".
  #
  # This is especially useful for sites that require email verifications.
  # Their 'connected with admin' item won't show up until they verify.
  def self.global_feed
    find(:all, 
         :joins => "INNER JOIN users ON users.id = activities.user_id",
         :order => 'activities.created_at DESC',
         :limit => GLOBAL_FEED_SIZE)
  end
  
  def self.all_activities(user)
    if self.count(:conditions => ["user_id in (select user_id from groups_users where group_id in (?)) and created_at >= ?", user.groups, PAST_THREE_DAYS]) > 0
      return true
    end
      return false
  end
  
  def self.related_activities(user)
    find(:all, 
    :conditions => ["user_id in (select user_id from groups_users where group_id in (?)) and created_at >= ?", user.groups, PAST_THREE_DAYS],
    :order => "id DESC",
     :limit => GLOBAL_FEED_SIZE) 
  end
  
  # def self.related_activities(user)
  #     find(:all, 
  #          :joins => "INNER JOIN users on users.id = activities.user_id",
  #          :conditions => ["user_id in (select user_id from groups_users where group_id in (?)) and created_at >= ?", user.groups, PAST_THREE_DAYS],
  #          :order => "activities.created_at desc") 
  # end
  
    
  # Return true if the item and user already exist.
  def self.exists?(item, user)
    find(:all, :conditions => ["item_id = ? and item_type = ? and user_id = ?", item.id, item.class.to_s, user.id]).nil?
  end
  
end