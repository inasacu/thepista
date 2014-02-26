class Mobile::GroupController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def starred_groups
    starred = Group.starred
    if !starred.nil?
      success_response(starred)
    else
      error_response("Not possible to get the starred groups")
    end
  end
  
  def groups_by_user
    user_id = params[:user_id]
    groups = Group.user_groups(user_id)
    if !groups.nil?
      success_response(groups)
    else
      error_response("Not possible to get the groups of the user")
    end
  end

  def create_group
    # temporarily
    new_group = Group.create_new(params)
    if !new_group.nil?
      success_response(new_group)
    else
      error_response("Not possible to create the group")
    end
  end

end