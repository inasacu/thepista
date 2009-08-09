class Topic < ActiveRecord::Base
  belongs_to  :forum,   :counter_cache => true
  belongs_to  :user
  has_many    :posts,   :dependent => :delete_all 
  
  validates_presence_of     :name,          :within => NAME_RANGE_LENGTH
  
  def self.per_page
    8
  end
  
end
