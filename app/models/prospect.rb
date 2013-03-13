# TABLE "prospect"
# t.string			:name
# t.string			:contact
# t.string			:email
# t.string			:email_additional
# t.string			:phone
# t.string			:url
# t.string			:url_additional
# t.string			:image
# t.text				:installations
# t.text				:description
# t.text				:conditions
# t.text				:notes
# t.datetime		:letter_first
# t.datetime		:letter_second
# t.datetime		:response_first
# t.datetime		:response_second


class Prospect < ActiveRecord::Base

	# validations 
	# validates_uniqueness_of   :name,    :case_sensitive => false
	# validates_presence_of     :name

	# variables to access
	attr_accessible :name, :contact, :email, :email_additional, 	:phone, :url, :url_additional,:image,:installations
	attr_accessible :description,:conditions,:notes,:letter_first,	:letter_second,:response_first,:response_second
	attr_accessible :archive

end

