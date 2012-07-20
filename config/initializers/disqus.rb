
ENV['DISQUS_SECRET_KEY'] = 'JKdz3WgZFZq7lmfV1whprURJk8QjIgVX6jV2LIqubmLvkbpLmZPfRlPWTm9Hg7YD'


# thepista.local
if Rails.env.development?
	ENV['THE_HOST'] = 'http://thepista.dev'
end

# thepista.heroku.com
if Rails.env.test?
	ENV['THE_HOST'] = 'http://thepista-heroku'  
end

# thepista.heroku.com
if Rails.env.staging?
	ENV['THE_HOST'] = 'http://thepista-heroku'
end

# haypista.com
if Rails.env.production? 
	# ENV['THE_HOST'] = 'http://zurb-herokuapp'
	ENV['THE_HOST'] = 'http://haypista'
end

