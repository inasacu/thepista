class Mobile::UserController < Mobile::SecurityController
    
  def user_registration
    # temporarily
    #new_user = User.user_registration(params)
    new_user = User.new
    logger.info "TEST #{params.inspect}"
    if !new_user.nil?
      success_response(new_user)
    else
      error_response("Error creating user")
    end
  end

end