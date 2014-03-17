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
    #new_group = Mobile::GroupM.new
    if !new_group.nil?
      success_response(new_group)
    else
      error_response("Not possible to create the group")
    end
  end

  def add_member
    add_response = Group.add_member(params[:group_id], params[:user_id])
    if !add_response.nil?
      success_response(add_response)
    else
      error_response("Not possible to add member to group")
    end
  end

  def get_info_related_to_user
    group_user_info = Group.get_info_related_to_user(params[:group_id], params[:user_id])
    if !group_user_info.nil?
      success_response(group_user_info)
    else
      error_response("Not possible to get group info")
    end
  end

end