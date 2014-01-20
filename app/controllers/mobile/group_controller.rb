class Mobile::GroupController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def starred_groups
    starred = Group.starred
    success_response(starred)
  end
  
  def groups_by_user
    user_id = params[:user_id]
    groups = Group.user_groups(user_id)
    success_response(groups)
  end

end