module ChallengesHelper

  def challenge_show_photo(challenge, current_user)
    the_first_manager = challenge.all_the_managers.first
    
    if the_first_manager.photo_file_name
      return item_image_link_medium(the_first_manager)
    end
    if current_user.is_manager_of?(challenge)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_challenge_path(challenge))}"
    else  
      return item_image_link_medium(the_first_manager)
    end
  end

  def challenge_vs_invite(schedule)
    item_name_link(schedule.challenge)  
  end

  def challenge_score_link(schedule)
    return "#{schedule.home_challenge} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_challenge}" 
  end    

  def challenge_list(objects)
    return item_list(objects)
  end
  
end
