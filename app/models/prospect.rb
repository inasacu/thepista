# == Schema Information
#
# Table name: prospects
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  contact          :string(255)
#  email            :string(255)
#  email_additional :string(255)
#  phone            :string(255)
#  url              :string(255)
#  url_additional   :string(255)
#  letter_first     :datetime
#  letter_second    :datetime
#  response_first   :datetime
#  response_second  :datetime
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string(255)
#  installations    :text
#  description      :text
#  conditions       :text
#  archive          :boolean          default(FALSE)
#

class Prospect < ActiveRecord::Base

	# validations 
	# validates_uniqueness_of   :name,    :case_sensitive => false
	# validates_presence_of     :name

	# variables to access
	attr_accessible :name, :contact, :email, :email_additional, 	:phone, :url, :url_additional,:image,:installations
	attr_accessible :description,:conditions,:notes,:letter_first,	:letter_second,:response_first,:response_second
	attr_accessible :archive

end

