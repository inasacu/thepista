class Activity < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :item,      :polymorphic => true
  # has_many    :feeds,     :dependent => :destroy
  
  def self.all_activities(user)
    if self.count(:conditions => ["user_id in (select distinct user_id from groups_users where group_id in (?) union
                                select distinct user_id from challenges_users where challenge_id in (?)) and created_at >= ?", user.groups, user.challenges, PAST_THREE_DAYS]) > 0
      return true
    end
    return false
  end
  
  def self.related_activities(user)
    find(:all, 
    :conditions => ["user_id in (select distinct user_id from groups_users where group_id in (?) union
                                select distinct user_id from challenges_users where challenge_id in (?)) and created_at >= ?", user.groups, user.challenges, PAST_THREE_DAYS],
    :order => "id DESC", :limit => GLOBAL_FEED_SIZE) 
  end
  
  def self.current_activities
    find(:all, :conditions => ["created_at >= ?", LAST_WEEK], :order => "id DESC", :limit => GLOBAL_FEED_SIZE) 
  end 
    
  # Return true if the item and user already exist.
  def self.exists?(item, user)
    find(:first, :conditions => ["item_id = ? and item_type = ? and user_id = ? and created_at >= ?", item.id, item.class.to_s, user.id, LAST_24_HOURS]).nil?
  end
  
end