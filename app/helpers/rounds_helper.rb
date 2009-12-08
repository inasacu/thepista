module RoundsHelper

  # Link to a round (default is by name).
  def round_link(text, round = nil, html_options = nil)
    if round.nil?
      round = text
      text = round.name
    elsif round.is_a?(Hash)
      html_options = round
      round = text
      text = round.name
    end
    # We normally write link_to(..., round) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), round, html_options)
  end

  def round_show_photo(round, current_user)
    if round.photo_file_name
      # return image_tag(round.photo.url)
      return round_image_link_large(round)
    end
    if current_user.is_manager_of?(round)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_round_path(round))}"
    else  
      return round_image_link_large(round)
    end
  end

  def round_image_link_tiny(round)
    link_to(image_tag(round.avatar, options={:style => "height: 15px; width: 15px;"}), round_path(round))
  end

  def round_image_link_small(round)
    link_to(image_tag(round.avatar, options={:style => "height: 30px; width: 30px;"}), round_path(round)) 
  end

  def round_image_link_medium(round)
    link_to(image_tag(round.avatar, options={:style => "height: 55px; width: 55px;"}), round_path(round))
  end

  def round_image_link_large(round)
    link_to(image_tag(round.avatar, options={:style => "height: 80px; width: 80px;"}), round_path(round))
  end

  def round_vs_invite(schedule)
    round_link schedule.round  
  end

  def round_score_link(schedule)
    return "#{schedule.home_round} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_round}" 
  end    

  def round_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{round_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end

