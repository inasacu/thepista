Rails.application.config.middleware.use OmniAuth::Builder do

	provider		:twitter, 		'ZYcd7am0utLk6A4REEbiaw', 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
	provider 		:browser_id
	provider 		:google, 'haypista.com', 'nADL4+fm3q1DIqpbUYnWBPBE'

	if Rails.env.development?
		provider 	:facebook,		'503725422971581', '93b9ffce01692d855a756bc51619f2d2' 
		provider 	:linkedin,		'6uezehrhpsxg', 'PX4ePvBeZ17O2Twc' 
	end

	unless Rails.env.development?
		provider 	:facebook,		'64553101275', 'e6425a5b426fa550a57b027e4ffe2dd4'				
		provider 	:linkedin,		'gb7lo5u6pmse', '9SYISnZCVF9nUd28'
	end

end


# This is a list of the strategies that are available for OmniAuth version 1.0 and later. 
# https://github.com/intridea/omniauth/wiki/List-of-Strategies

