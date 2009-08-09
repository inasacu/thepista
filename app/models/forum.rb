class Forum < ActiveRecord::Base
  has_many      :topics,    :dependent => :delete_all
  has_many      :posts,     :through => :topics
  
  belongs_to    :schedule
  
  validates_presence_of   :name, :description
  
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH  
end
