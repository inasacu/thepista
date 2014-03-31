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
    link_to(image_tag(IMAGE_CUP, options={:style => "height: 15px; width: 15px;"}), cup_path(cup)) 
  end

  def view_cup_name(cup, show_price=false) 
    is_member_and_not_mock = (cup.public)

    the_sport = ""  
    the_missing = ""
    the_concept = ""
    the_image = ""
    the_price = ""
    the_prematch_player = ""
    show_price = (Time.zone.now < cup.starts_at) ? show_price : false
    the_concept = is_member_and_not_mock ? link_to(sanitize(limit_url_length(cup.name, 25)), cup_path(:id => cup)) : sanitize(limit_url_length(cup.name))

    the_sport = "#{the_font_green(label_name(:rosters))}:  #{cup.escuadras.count}"
    the_missing = ", #{the_font_yellow(I18n.t(:missing))}:  #{cup.player_limit.to_i - cup.escuadras.count}" if cup.player_limit.to_i > cup.escuadras.count
    the_missing = ", #{the_font_red(I18n.t(:excess))}:  #{cup.escuadras.count - cup.player_limit.to_i}" if cup.player_limit.to_i < cup.escuadras.count
    the_price = "<br/><STRONG>#{label_name(:fee_per_game_short)}:</STRONG> #{number_to_currency(cup.fee_per_game)}" if show_price


    the_span = set_content_tag_safe('span', "    #{the_sport} #{the_missing} #{the_price}", 'date')  
    return set_content_tag_safe('td', "#{the_image}  #{the_concept}<br />#{the_span}", 'name_and_date')
  end

  def view_cup_starts_at(cup)
    the_date = "#{nice_day_of_week(cup.starts_at)} <br /> #{has_left(cup.starts_at)}" if Time.zone.now < cup.starts_at
    return set_content_tag_safe(:td, "#{the_date}", 'name_and_date')
  end

  def view_cup_user(cup)
    the_span = content_tag('span', "#{cup.city.name}, #{cup.sport.name}", :class => 'date')
    return set_content_tag_safe(:td, "#{item_list(cup.all_the_managers)}<br />#{the_span}", 'name_and_date')
  end

  def view_cup_rating(cup)
    if Time.zone.now < cup.starts_at
      the_label = ""
      the_match_link = ""
      is_escuadra_member = false

      cup.escuadras.each do |escuadra|
        if current_user.is_member_of?(escuadra)
          is_escuadra_member = true      
        end
      end
      
      the_match_link = "#{set_image_and_link(link_to(label_name(:escuadras_create), new_escuadra_path(:id => cup)))}" unless is_escuadra_member

      return set_content_tag_safe(:td, "#{the_label}<br/>#{the_match_link}", "last_upcoming")
    end
  end


end

