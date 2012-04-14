module CupsHelper

  def cup_link(text, item = nil, html_options = nil)
    item_name_link(text, item, html_options)
  end
  
  def cup_show_photo(cup, current_user)
    if cup.photo_file_name
      return item_image_link_large(cup)
    end
    if is_current_manager_of(cup)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_cup_path(cup))}"
    else  
      return item_image_link_large(cup)
    end
  end

  def cup_list(objects)
    return item_list(objects)
  end
    
  def cup_avatar_image_link(cup)
    link_to(image_tag('icons/cup.png', options={:style => "height: 15px; width: 15px;"}), cup_path(cup)) 
  end

end

