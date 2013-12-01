class Mobile::UserController < ActionController::Base
  
  def my_groups
    user_id = params[:user_id]
    user = User.find(user_id)
    render json: user.groups
  end
  
  def my_active_events
    user_id = params[:user_id]
    user = User.find(user_id)
    render json: user.active_events
  end
  
  def my_groups_events
    user_id = params[:user_id]
    user = User.find(user_id)
    render json: user.groups_events
  end

end