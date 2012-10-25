Rails.application.config.middleware.use OmniAuth::Builder do

	provider		:twitter, 		'ZYcd7am0utLk6A4REEbiaw', 'HVyuCmtaWLh849Rt050DvIDErsb1wvfbtVZsI3Q'
	provider 		:browser_id
	provider 		:google, 'haypista.com', 'nADL4+fm3q1DIqpbUYnWBPBE'

	if Rails.env.development?
		provider 	:facebook,		'503725422971581', '93b9ffce01692d855a756bc51619f2d2' 
		provider 	:linkedin,		'6uezehrhpsxg', 'PX4ePvBeZ17O2Twc' 
		# provider 	:yahoo,				'dj0yJmk9cmZwakg2dkhqdWRsJmQ9WVdrOU1XaHNlazQyTnpJbWNHbzlOVGcwT1RReE5UWXkmcz1jb25zdW1lcnNlY3JldCZ4PTBi','53f734979ce3eca38ba1c37f29e1f4fa0ef5c0ec'


	else

		provider 	:facebook,		'64553101275', 'e6425a5b426fa550a57b027e4ffe2dd4'				
		provider 	:linkedin,		'VR4hkAI9HEzx4-2S6ueyPc6YJ3uX3GuE88E_YNKT0Jj-4UeClY_k9HNGBSEIOOaP', 'vA1Bp9IQmjboOBxggQRAeyNGqbkUKWq4MVkeFU7kUanD3Aqan7QlIRPUDEkGmv5'
		# provider	:yahoo, 			'dj0yJmk9eHNNaG1WQ1JBTTRjJmQ9WVdrOVkycERSRkJWTm5VbWNHbzlNVGt4TWpreE5UQTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1jZg--', '28f1ca827605668fb7e4e74e4dc99f84f68898d9'
	end


	# provider		:disqus,	'VBmKngexydpoyOktoxdgkrMoJctJQKft1Rgzl3qztvbrnPtLUqaHEw2HflJWmmlj','JKdz3WgZFZq7lmfV1whprURJk8QjIgVX6jV2LIqubmLvkbpLmZPfRlPWTm9Hg7YD'
end


# This is a list of the strategies that are available for OmniAuth version 1.0 and later. 
# https://github.com/intridea/omniauth/wiki/List-of-Strategies

