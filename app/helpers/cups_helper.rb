module CupsHelper
  
  # Link to a cup (default is by name).
  def cup_link(text, cup = nil, html_options = nil)
    if cup.nil?
      cup = text
      text = cup.name
    elsif cup.is_a?(Hash)
      html_options = cup
      cup = text
      text = cup.name
    end
    link_to(h(text), cup, html_options)
  end

  def cup_show_photo(cup, current_user)
    if cup.photo_file_name
      return cup_image_link_large(cup)
    end
    if current_user.is_manager_of?(cup)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_cup_path(cup))}"
    else  
      return cup_image_link_large(cup)
    end
  end

  def cup_image_link_tiny(cup)
    link_to(image_tag(cup.avatar, options={:style => "height: 15px; width: 15px;"}), cup_path(cup)) 
  end

  def cup_image_link_smaller(cup)
    link_to(image_tag(cup.avatar, options={:style => "height: 22px; width: 22px;"}), cup_path(cup)) 
  end
  
  def cup_image_link_small(cup)
    link_to(image_tag(cup.avatar, options={:style => "height: 30px; width: 30px;", :title => h(cup.name)}), cup_path(cup)) 
  end

  def cup_image_link_medium(cup)
    link_to(image_tag(cup.avatar, options={:style => "height: 55px; width: 55px;"}), cup_path(cup))
  end

  def cup_image_link_large(cup)
    link_to(image_tag(cup.avatar, options={:style => "height: 80px; width: 80px;"}), cup_path(cup))
  end
    
  def cup_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{cup_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end

