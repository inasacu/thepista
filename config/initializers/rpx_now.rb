
# thepista.local
if Rails.env.development?
	ENV['RPX_API_KEY'] = 'f7bbfeed95a9e71fe994397d496614da8972aa2c'
	ENV['RPX_APP_NAME'] = 'thepista-dev'
end

# thepista.heroku.com
if Rails.env.test?
	ENV['RPX_API_KEY'] = "59b7bd4a615a2c17439b6a4ca064a1d5f482944e" 
	ENV['RPX_APP_NAME'] = "zurb-heroku"  
end

# thepista.heroku.com
if Rails.env.staging?
	ENV['RPX_API_KEY'] = "59b7bd4a615a2c17439b6a4ca064a1d5f482944e" 
	ENV['RPX_APP_NAME'] = "zurb-heroku"
end

# haypista.com
if Rails.env.production?
	ENV['RPX_API_KEY'] = "2acf2c6b39e3d1d988629e0cb41c675827c2f45e"   
	ENV['RPX_APP_NAME'] = "haypista"  
end