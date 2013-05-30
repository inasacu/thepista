# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  city_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Customer < ActiveRecord::Base

	belongs_to			:user
	belongs_to			:city
	
	# validations 
  validates_uniqueness_of   :phone,           :case_sensitive => false
  validates_presence_of     :name         
  

  # variables to access
  attr_accessible :name, :email, :phone, :city_id, :user_id

end
