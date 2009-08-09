class Type < ActiveRecord::Base
  
  has_many  :matches
  
  # validations 
  validates_uniqueness_of   :name
  validates_presence_of     :name,          :within => NAME_RANGE_LENGTH
  
  def self.find_type_match
    find_by_sql("select * from types where table_type = 'Match'")
  end
end
