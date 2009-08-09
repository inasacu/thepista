class Sport < ActiveRecord::Base

  has_many :groups
  has_many :markers

  # # validations 
  # validates_uniqueness_of   :name
  # validates_presence_of     :name,          :within => NAME_RANGE_LENGTH  
  # 
  # def self.sport_name
  #   find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
  # end  
end