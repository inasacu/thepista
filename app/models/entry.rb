class Entry < ActiveRecord::Base
  
  has_many    :comments,   :dependent => :delete_all
  
  belongs_to  :blog,   :counter_cache => true
  belongs_to  :user
  belongs_to  :group

  validates_presence_of   :title, :body
  validates_length_of     :title,           :within => SUBJECT_RANGE_LENGTH
  validates_length_of     :body,            :within => BODY_RANGE_LENGTH
end
