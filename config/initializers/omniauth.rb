Rails.application.config.middleware.use OmniAuth::Builder do

	provider		:twitter, 		ENV["TWITTER_KEY"], ENV["TWITTER_SECOND_KEY"]
	provider 		:google, 			ENV["GOOGLE_KEY"], ENV["GOOGLE_SECOND_KEY"]

	provider    :browser_id, 		:failure_path => '/failure'

	if Rails.env.development?
		provider 	:facebook,		ENV["DEV_FACEBOOK_KEY"], ENV["DEV_FACEBOOK_SECOND_KEY"] 
		
	else
		provider 	:facebook,		ENV["FACEBOOK_KEY"], ENV["FACEBOOK_SECOND_KEY"] 
		
	end


	case Rails.env
	when 'development'
		provider 	:windowslive,       ENV["DEV_WINODWSLIVE_KEY"], ENV["DEV_WINODWSLIVE_SECOND_KEY"], :scope => 'wl.basic'
		
		provider 	:yahoo,				      ENV["YAHOO_KEY"], ENV["YAHOO_SECOND_KEY"]
		provider 	:linkedin,		      ENV["DEV_LINKEDIN_KEY"], ENV["DEV_LINKEDIN_SECOND_KEY"]
		
	when 'staging'
		provider 	:windowslive,       ENV["STAGE_WINODWSLIVE_KEY"], ENV["STAGE_WINODWSLIVE_SECOND_KEY"], :scope => 'wl.basic'
		
		provider 	:yahoo,				      ENV["YAHOO_KEY"], ENV["YAHOO_SECOND_KEY"]
		provider 	:linkedin,		      ENV["STAGE_LINKEDIN_KEY"], ENV["STAGE_LINKEDIN_SECOND_KEY"]
	
	when 'production'
		provider 	:windowslive,       ENV["WINODWSLIVE_KEY"], ENV["WINODWSLIVE_SECOND_KEY"], :scope => 'wl.basic'
		
		provider 	:yahoo,				      ENV["YAHOO_KEY"], ENV["YAHOO_SECOND_KEY"]
		provider 	:linkedin,		      ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECOND_KEY"]
		

	end
end


# This is a list of the strategies that are available for OmniAuth version 1.0 and later. 
# https://github.com/intridea/omniauth/wiki/List-of-Strategies
