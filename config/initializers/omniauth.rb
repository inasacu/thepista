Rails.application.config.middleware.use OmniAuth::Builder do

	provider		:twitter, 		'ZYcd7am0utLk6A4REEbiaw', 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
	provider 		:browser_id
	provider 		:google, 			'haypista.com', 'nADL4+fm3q1DIqpbUYnWBPBE'


	if Rails.env.development?
		provider 	:facebook,		'503725422971581', '93b9ffce01692d855a756bc51619f2d2' 
		provider 	:linkedin,		'6uezehrhpsxg', 'PX4ePvBeZ17O2Twc' 
		
			provider 	:windowslive, '00000000480F1893', '5m702Q59TUnuoX-O6rXLdzqhN7aaUdP0', :scope => 'wl.basic'
			provider 	:yahoo,				'dj0yJmk9RkRMUW9MNm9EcnUyJmQ9WVdrOVVrMVZPRGhoTlRBbWNHbzlNVFUyT1RZMU56QTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1kOQ--', '2aa1f60dda04eb8cbcf53c8581227d777f2a1cd6'
	else
		provider 	:facebook,		'273731636077992', '9f7013153c332f7d6b666814b8f6c7f0'				
		provider 	:linkedin,		'gb7lo5u6pmse', '9SYISnZCVF9nUd28'
	end




	# case ActionDispatch::Request.env["HTTP_HOST"]
	
	# when 'thepista.dev'
	# 
	# when 'thepista.com'
		provider 	:windowslive, '00000000480F1894', 'vWDbGvp1W1UA5Chuk16OSkfcyzXD5-d1', :scope => 'wl.basic'
		provider 		:yahoo,				'dj0yJmk9bXlmYndneVNkZno2JmQ9WVdrOVFWWjJPVzU0TldFbWNHbzlNVGN6TkRReU5EazJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD01NQ--', '12780fa275c074378cdc51b135056e382a017043'
	# 
	# when 'haypista.com'
	# 	provider 	:windowslive, '00000000400F4667', 'xPYA7qeulbBMWcQPCmKu2EbmSNGUUapE', :scope => 'wl.basic'
	# 	provider 	:yahoo,				'dj0yJmk9UmM5SmZ0cUpDZFJuJmQ9WVdrOVNYYzNUbTQyTXpJbWNHbzlNalExTkRVMU5qWXkmcz1jb25zdW1lcnNlY3JldCZ4PWEy', 'd0c00ee680e35d1ec052c5cc4fcec9c4947242f8'
	# end


end


# This is a list of the strategies that are available for OmniAuth version 1.0 and later. 
# https://github.com/intridea/omniauth/wiki/List-of-Strategies
