
ENV['DISQUS_SECRET_KEY'] = 'JKdz3WgZFZq7lmfV1whprURJk8QjIgVX6jV2LIqubmLvkbpLmZPfRlPWTm9Hg7YD'


# thepista.dev
if Rails.env.development?
	ENV['THE_HOST'] = 'http://thepista.dev'
end

# thepista.com
if Rails.env.staging?
	ENV['THE_HOST'] = 'http://thepista.com'
end

# haypista.com
if Rails.env.production? 
	ENV['THE_HOST'] = 'http://haypista.com'
end

