class Mobile::UserController < Mobile::SecurityController
    
  def user_registration
    # temporarily
    new_user = Mobile::UserM.user_registration(params)
    #new_user = User.new
    if !new_user.nil?
      success_response()
    else
      error_response("Error creating user")
    end
  end

  def user_logout
    user_id = params[:user_id]
    if Mobile::UserM.user_logout(user_id)
      success_response(true)
    else
      error_response("Error logginf out the user")
    end
  end

  def user_account_info
    user_id = params[:user_id]
    user_info = Mobile::UserM.user_account_info(user_id)
    if !user_info.nil?
      success_response(user_info)
    else
      error_response("Error obtaining user info")
    end
  end

end