class Rate < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :rateable, :polymorphic => true
  
  attr_accessible :rate, :dimension
end
