# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentication < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id, :uid, :provider
	validates_uniqueness_of :uid, :scope => :provider

	def self.find_from_omniauth(omniauth)
		find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
	end

	def self.create_from_omniauth(omniauth, user = nil)
		# user ||= User.create_from_omniauth!(omniauth)
		Authentication.create(:user => user, :uid => omniauth['uid'], :provider => omniauth['provider']) unless user.nil?
	end	

end
