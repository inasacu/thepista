module EscuadrasHelper

  # Link to a escuadra (default is by name).
  def escuadra_link(text, escuadra = nil, html_options = nil)
    if escuadra.nil?
      escuadra = text
      text = escuadra.name
    elsif escuadra.is_a?(Hash)
      html_options = escuadra
      escuadra = text
      text = escuadra.name
    end
    # We normally write link_to(..., escuadra) for brevity, but that breaks
    
    link_to(h(text), escuadra, html_options)
  end

  def escuadra_show_photo(escuadra, current_user)
    if escuadra.photo_file_name
      # return image_tag(escuadra.photo.url)
      return escuadra_image_link_large(escuadra)
    end
    if current_user.is_manager_of?(escuadra)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_escuadra_path(escuadra))}"
    else  
      return escuadra_image_link_large(escuadra)
    end
  end

  def escuadra_image_link_tiny(escuadra)
    link_to(image_tag(escuadra.avatar, options={:style => "height: 13px; width: 19px;"}), escuadra_path(escuadra)) 
  end

  def escuadra_image_link_smaller(escuadra)
    link_to(image_tag(escuadra.avatar, options={:style => "height: 21px; width: 34px;"}), escuadra_path(escuadra)) 
  end

  def escuadra_image_link_small(escuadra)
    link_to(image_tag(escuadra.avatar, options={:style => "height: 31px; width: 47px;", :title => h(escuadra.name)}), escuadra_path(escuadra)) 
  end

  # def escuadra_image_link_medium(escuadra)
  #   link_to(image_tag(escuadra.avatar, options={:style => "height: 55px; width: 55px;"}), escuadra_path(escuadra))
  # end
  # 
  # def escuadra_image_link_large(escuadra)
  #   link_to(image_tag(escuadra.avatar, options={:style => "height: 80px; width: 80px;"}), escuadra_path(escuadra))
  # end

  def escuadra_vs_invite(game)
    escuadra_link game.escuadra  
  end

  def escuadra_score_link(game)
    return "#{game.home} ( #{game.home_score}  -  #{game.away_score} ) #{game.away}" 
  end    

  def escuadra_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{escuadra_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end
