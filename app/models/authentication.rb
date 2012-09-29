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
