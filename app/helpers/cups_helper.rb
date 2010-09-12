module CupsHelper

  def cup_show_photo(cup, current_user)
    if cup.photo_file_name
      return item_image_link_large(cup)
    end
    if current_user.is_manager_of?(cup)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_cup_path(cup))}"
    else  
      return item_image_link_large(cup)
    end
  end

  def cup_list(objects)
    return item_list(objects)
  end

end

