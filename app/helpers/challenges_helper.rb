module ChallengesHelper
  # Link to a challenge (default is by name).
  def challenge_link(text, challenge = nil, html_options = nil)
    if challenge.nil?
      challenge = text
      text = challenge.name
    elsif challenge.is_a?(Hash)
      html_options = challenge
      challenge = text
      text = challenge.name
    end
    # We normally write link_to(..., challenge) for brevity, but that breaks
    
    link_to(h(text), challenge, html_options)
  end

  def challenge_show_photo(challenge, current_user)
    if challenge.photo_file_name
      # return image_tag(challenge.photo.url)
      return challenge_image_link_large(challenge)
    end
    if current_user.is_manager_of?(challenge)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_challenge_path(challenge))}"
    else  
      return challenge_image_link_large(challenge)
    end
  end

  def challenge_image_link_tiny(challenge)
    link_to(image_tag(challenge.avatar, options={:style => "height: 15px; width: 15px;"}), challenge_path(challenge)) 
  end

  def challenge_image_link_smaller(challenge)
    link_to(image_tag(challenge.avatar, options={:style => "height: 22px; width: 22px;"}), challenge_path(challenge)) 
  end

  def challenge_image_link_small(challenge)
    link_to(image_tag(challenge.avatar, options={:style => "height: 30px; width: 30px;", :title => h(challenge.name)}), challenge_path(challenge)) 
  end

  def challenge_image_link_medium(challenge)
    link_to(image_tag(challenge.avatar, options={:style => "height: 55px; width: 55px;"}), challenge_path(challenge))
  end

  def challenge_image_link_large(challenge)
    link_to(image_tag(challenge.avatar, options={:style => "height: 80px; width: 80px;"}), challenge_path(challenge))
  end

  def challenge_vs_invite(schedule)
    challenge_link schedule.challenge  
  end

  def challenge_score_link(schedule)
    return "#{schedule.home_challenge} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_challenge}" 
  end    

  def challenge_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{challenge_link object}, "      
    end
    return list_of_objects.chop.chop
  end
end
