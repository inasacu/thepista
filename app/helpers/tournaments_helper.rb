module TournamentsHelper

  # Link to a tournament (default is by name).
  def tournament_link(text, tournament = nil, html_options = nil)
    if tournament.nil?
      tournament = text
      text = tournament.name
    elsif tournament.is_a?(Hash)
      html_options = tournament
      tournament = text
      text = tournament.name
    end
    # We normally write link_to(..., tournament) for brevity, but that breaks
    
    link_to(h(text), tournament, html_options)
  end

  def tournament_show_photo(tournament, current_user)
    if tournament.photo_file_name
      # return image_tag(tournament.photo.url)
      return tournament_image_link_large(tournament)
    end
    if current_user.is_manager_of?(tournament)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_tournament_path(tournament))}"
    else  
      return tournament_image_link_large(tournament)
    end
  end

  def tournament_image_link_tiny(tournament)
    link_to(image_tag(tournament.avatar, options={:style => "height: 15px; width: 15px;"}), tournament_path(tournament))
  end

  def tournament_image_link_small(tournament)
    link_to(image_tag(tournament.avatar, options={:style => "height: 30px; width: 30px;"}), tournament_path(tournament)) 
  end

  def tournament_image_link_medium(tournament)
    link_to(image_tag(tournament.avatar, options={:style => "height: 55px; width: 55px;"}), tournament_path(tournament))
  end

  def tournament_image_link_large(tournament)
    link_to(image_tag(tournament.avatar, options={:style => "height: 80px; width: 80px;"}), tournament_path(tournament))
  end

  def tournament_vs_invite(schedule)
    tournament_link schedule.tournament  
  end

  def tournament_score_link(schedule)
    return "#{schedule.home_tournament} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_tournament}" 
  end    

  def tournament_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{tournament_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end

