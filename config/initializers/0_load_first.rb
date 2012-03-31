
# Methods in this file need to be loaded first.
# This is because other initializers may depend on them.
# The funky filename?  Rails loads the initializers in alphabetical order.

def development?
	environment_is('development')
end

def test?
	environment_is('test')
end

def production?
	environment_is('production')	
end

def environment_is(env)
	Rails.env == env
end
