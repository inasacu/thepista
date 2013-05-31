Rails.application.config.middleware.use OmniAuth::Builder do

	provider		:twitter, 		'ZYcd7am0utLk6A4REEbiaw', 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
	provider 		:google, 			'haypista.com', 'nADL4+fm3q1DIqpbUYnWBPBE'

	provider :browser_id, 		:failure_path => '/failure'

	if Rails.env.development?
		provider 	:facebook,		'503725422971581', '93b9ffce01692d855a756bc51619f2d2' 
		
	else
		provider 	:facebook,		'273731636077992', '9f7013153c332f7d6b666814b8f6c7f0'	
		
	end


	case Rails.env
	when 'development'
		provider 	:windowslive, '00000000480F1893', '5m702Q59TUnuoX-O6rXLdzqhN7aaUdP0', :scope => 'wl.basic'
		provider 	:yahoo,				'dj0yJmk9Wk9Fb1c1dm9nVWQ5JmQ9WVdrOVVrMVZPRGhoTlRBbWNHbzlNVFUyT1RZMU56QTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1iZg--', '21b23b52d3376af08adee8574716373929e087c4'
		provider 	:linkedin,		'6uezehrhpsxg', 'PX4ePvBeZ17O2Twc'
		
	when 'staging'
		provider 	:windowslive, '00000000480F1894', 'vWDbGvp1W1UA5Chuk16OSkfcyzXD5-d1', :scope => 'wl.basic'
		provider 		:yahoo,				'dj0yJmk9bXlmYndneVNkZno2JmQ9WVdrOVFWWjJPVzU0TldFbWNHbzlNVGN6TkRReU5EazJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD01NQ--', '12780fa275c074378cdc51b135056e382a017043'
		provider 	:linkedin,		'gl2wj4hrzkc1', 'm928rmFK2eNm9ZJf'
	
	when 'production'
		provider 	:windowslive, '00000000400F4667', 'xPYA7qeulbBMWcQPCmKu2EbmSNGUUapE', :scope => 'wl.basic'
		provider 	:yahoo,				'dj0yJmk9QzEyNnZNWkp1QVk3JmQ9WVdrOVNYYzNUbTQyTXpJbWNHbzlNalExTkRVMU5qWXkmcz1jb25zdW1lcnNlY3JldCZ4PTcy', 'bb726da6dc7409d881c155c81b7437295e5529b2'
		provider 	:linkedin,		'gb7lo5u6pmse', '9SYISnZCVF9nUd28'
		
	end


end


# This is a list of the strategies that are available for OmniAuth version 1.0 and later. 
# https://github.com/intridea/omniauth/wiki/List-of-Strategies
