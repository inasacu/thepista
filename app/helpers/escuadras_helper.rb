module EscuadrasHelper

  def escuadra_link(text, escuadra = nil, html_options = nil)
    if escuadra.nil?
      escuadra = text
      text = escuadra.name
    elsif escuadra.is_a?(Hash)

      escuadra = escuadra.item
      html_options = escuadra
      escuadra = text
      text = escuadra.name
    end

    link_to(h(text), escuadra, html_options)
  end

  def escuadra_show_photo(escuadra, current_user)
    if escuadra.photo_file_name
      return escuadra_image_link_large(escuadra)
    end
    if current_user.is_manager_of?(escuadra)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_escuadra_path(escuadra))}"
    else  
      return escuadra_image_link_large(escuadra)
    end
  end

  def escuadra_image_link_smaller(escuadra)
    is_escuadra = (escuadra.item_type == 'Escuadra')
    escuadra = escuadra.item
    if is_escuadra
      link_to(image_tag(escuadra.avatar, options={:style => "height: 21px; width: 31px;"}), escuadra_path(escuadra))
    else
      link_to(image_tag(escuadra.avatar, options={:style => "height: 22px; width: 22px;"}), escuadra_path(escuadra))
    end
  end

  def escuadra_vs_invite(game)
    escuadra_link game.escuadra  
  end

  def escuadra_score_link(game)
    return "#{game.home} ( #{game.home_score}  -  #{game.away_score} ) #{game.away}" 
  end
end
