Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'ZYcd7am0utLk6A4REEbiaw', 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
	provider :browser_id
	
	# provider :facebook,	'266436120054287', '689ce045d1cb8a0f79ecf38903a47c6b' if Rails.env.development?
	# provider :facebook,	'64553101275', 'e6425a5b426fa550a57b027e4ffe2dd4'			if Rails.env.production?
	# provider :linkedin,	'VR4hkAI9HEzx4-2S6ueyPc6YJ3uX3GuE88E_YNKT0Jj-4UeClY_k9HNGBSEIOOaP', 'vA1Bp9IQmjboOBxggQRAeyNGqbkUKWq4MVkeFU7kUanD3Aqan7QlIRPUDEkGmv5'
end


# ENV['FACEBOOK_APPLICATION_ID'] = '64553101275'
# ENV['FACEBOOK_APPLICATION_SECRET'] = 'e6425a5b426fa550a57b027e4ffe2dd4'
# ENV['TWITTER_CONSUMER_KEY'] = 'ZYcd7am0utLk6A4REEbiaw'
# ENV['TWITTER_CONSUMER_SECRET'] = 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
# ENV['LINKEDIN_API_KEY'] = 'VR4hkAI9HEzx4-2S6ueyPc6YJ3uX3GuE88E_YNKT0Jj-4UeClY_k9HNGBSEIOOaP'
# ENV['LINKEDIN_SECRET_KEY'] = 'vA1Bp9IQmjboOBxggQRAeyNGqbkUKWq4MVkeFU7kUanD3Aqan7QlIRPUDEkGmv5'
# ENV['LIVE_CLIENT_ID']	= '00000000440103DE'
# ENV['LIVE_CLIENT_SECRET'] = 'MHkNHhiifMRrwqwoaDSsh1PlQ9wVpWFq'
# ENV['FOURSQUARE_CLIENT_ID']	= 'MRHOMIR2QONU0FDYRIIXXYW1OI2XBPWQLNDN422CRC4WY5WY'
# ENV['FOURSQUARE_CLIENT_SECRET'] = '524SFOEI4NGE1OQP2RF44TYDFZVSU204E4B0P4R1OS4ZJE1O'
# ENV['ORKUT_CONSUMER_KEY']	= 'haypista.rpxnow.com'
# ENV['ORKUT_CONSUMER_SECRET'] = 'JXdZOrTHaUEjFWUkROsxci9Q'
# ENV['DISQUS_CLIENT_ID']	= 'Y6rtlHMm5poFm6AmHNMgaZNiOmEy9zTOwlTRA6fzdZVnlLiqh0NZTpuiZHN5lLfq'
# ENV['DISQUS_CLIENT_SECRET'] = '5TSKHpgIEDB57nJm2Mrs5Xn10bYF2muFlmhc5hjfGPf7fzg8KN1FJB4kHl0y7eT9'
# ENV['MYSPACE_CONSUMER_KEY']	= 'http://www.myspace.com/447648268'
# ENV['MYSPACE_CONSUMER_SECRET'] = '4386a09451af47e39ba9e6decd2df236


# /auth/twitter
# /auth/twitter/callback