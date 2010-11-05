module GroupsHelper
  
  # Link to a group (default is by name).
  def group_link(text, item = nil, html_options = nil)
    item_name_link(text, item, html_options)
  end

  def group_show_photo(group, current_user)
    if group.photo_file_name
      return item_image_link_large(group)
    end
    if current_user.is_manager_of?(group)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_group_path(group))}"
    else  
      return item_image_link_large(group)
    end
  end	
  
  def group_avatar_image_link(group)
    link_to(image_tag('group_avatar.png', options={:style => "height: 15px; width: 15px;"}), group_path(group)) 
  end
  
  def group_vs_invite(schedule)
    item_name_link(schedule.group)  
  end
  
  def group_score_link(schedule)
    return "#{schedule.home_group} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_group}" 
  end    
  
  def group_list(objects)
    return item_list(objects)
  end
  
end
