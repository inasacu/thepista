class Mobile::UserController < Mobile::SecurityController
  
  before_filter :check_active_token

end