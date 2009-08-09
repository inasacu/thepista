class Blog < ActiveRecord::Base
  
  has_many      :entries,      :dependent => :delete_all
  has_many      :comments,     :through => :entries
  
  belongs_to    :user
  belongs_to    :group

  validates_presence_of   :name, :description
  
  validates_length_of     :name,                :within => NAME_RANGE_LENGTH
  validates_length_of     :description,         :within => DESCRIPTION_RANGE_LENGTH
end
