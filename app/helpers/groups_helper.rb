module GroupsHelper
  
  # Link to a group (default is by name).
  def group_link(text, group = nil, html_options = nil)
    if group.nil?
      group = text
      text = group.name
    elsif group.is_a?(Hash)
      html_options = group
      group = text
      text = group.name
    end
    # We normally write link_to(..., group) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), group, html_options)
  end

  def group_show_photo(group)
    if group.photo_file_name
      return image_tag(group.photo.url)
    end
    "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_group_path(group))}"
  end

  def group_image_link_small(group)
    link_to(image_tag(group.avatar, options={:style => "height: 55px; width: 55px;"}), group_path(group))
  end
  
  def group_vs_invite(schedule)
    group_link schedule.group         
    # vs_invite +=  " vs. " + 
    # group_link schedule.invite_group if schedule.is_invite? 
    # return vs_invite
  end
  
  def group_score_link(schedule)
    home_visit = "#{group_link(schedule.group)}  #{schedule.matches.first.group_score}  -  #{schedule.matches.first.invite_score}  "  

    if schedule.is_invite? 
      home_visit += group_link(schedule.invite_group)
    else
      home_visit += schedule.group.second_team
    end
    return home_visit    
  end    
  
  def group_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{group_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end
