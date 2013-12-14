class Mobile::UserController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def my_groups
    user_id = params[:user_id]
    user = User.find(user_id)
    success_response(user.groups.select("groups.id, groups.name"))
  end
  
  def my_active_events
    user_id = params[:user_id]
    user = User.find(user_id)
    success_response(user.active_events)
  end
  
  def my_groups_events
    user_id = params[:user_id]
    user = User.find(user_id)
    success_response(user.groups_events)
  end

end