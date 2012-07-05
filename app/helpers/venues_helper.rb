module VenuesHelper

  def venue_show_photo(venue, current_user)
    if venue.photo_file_name
      return item_image_link_large(venue)
    end
    if is_current_manager_of(venue)
      "#{I18n.t(:no_photo_for, get_the_controller)}.  #{link_to(I18n.t(:upload), edit_venue_path(venue))}"
    else  
      return item_image_link_large(venue)
    end
  end	
  
  def venue_avatar_image_link(venue)
    link_to(image_tag(IMAGE_VENUE, options={:style => "height: 15px; width: 15px;"}), venue_path(venue)) 
  end
  
  def venue_vs_invite(schedule)
    item_name_link(schedule.venue)  
  end
  
  def venue_score_link(schedule)
    return "#{schedule.home_venue} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_venue}" 
  end    
  
  def venue_list(objects)
    return item_list(objects)
  end
  
  def set_role_venue_add_sub_manager(user, venue)
    the_label = label_with_name('role_add_sub_manager', h(venue.name))  
		link_to(the_label , set_sub_manager_path(:id => user, :venue => venue))
  end
  
  def set_role_venue_remove_sub_manager(user, venue)
    the_label = label_with_name('role_remove_sub_manager', h(venue.name))   
		link_to(the_label , remove_sub_manager_path(:id => user, :venue => venue))
  end
  
  def set_role_venue_add_subscription(user, venue)
    the_label = label_with_name('role_add_subscription', h(venue.name)) 
		link_to(the_label , set_subscription_path(:id => user, :venue => venue))
  end
  
  def set_role_venue_remove_subscription(user, venue)
    the_label = label_with_name('role_remove_subscription', h(venue.name))
		link_to(the_label , remove_subscription_path(:id => user, :venue => venue))
  end
end

