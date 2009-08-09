class Comment < ActiveRecord::Base
  belongs_to  :entry,   :counter_cache => true
  belongs_to  :user,    :counter_cache => true
  belongs_to  :group,   :counter_cache => true
end
