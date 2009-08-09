class Post < ActiveRecord::Base

# include ActivityLogger
# 
  belongs_to  :topic,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true
# 
#   after_create  :log_activity
# 
#   # variables
#   # POST_PER_PAGE = 15
#   # ONE_WEEK_FROM_TODAY = Time.now - 1.day..Time.now + 7.days
# 
#   def self.find_jornada_post(topic, page = 1)
#     paginate(:all, :conditions => ["topic_id = ?",  topic.id],
#     :order => "created_at DESC",
#     :page => page,
#     :per_page => POST_PER_PAGE)
#   end
# 
#   private
#   def log_activity
#     add_activities(:item => self, :user => self.user, :include_user => false)
#   end
end