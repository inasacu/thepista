class User < ActiveRecord::Base
  acts_as_messageable
end

class Men < User
end
