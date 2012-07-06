module ChallengesHelper

	def challenge_link(text, item = nil, html_options = nil)
		item_name_link(text, item, html_options)
	end

	def challenge_show_photo(challenge, current_user)
		the_first_manager = challenge.all_the_managers.first

		if the_first_manager.photo_file_name
			return item_image_link_medium(the_first_manager)
		end
		if is_current_manager_of(challenge)
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

	def challenge_avatar_image_link(challenge)
		link_to(image_tag(IMAGE_CHALLENGE, options={:style => "height: 15px; width: 15px;"}), challenge_path(challenge)) 
	end

	def set_role_add_challenge_subscription(user, challenge)
		the_label = label_with_name('role_add_subscription', challenge.name) 
		link_to(the_label , set_challenge_subscription_path(:id => user, :challenge => challenge))
	end

	def set_role_remove_challenge_subscription(user, challenge)
		the_label = label_with_name('role_remove_subscription', challenge.name)
		link_to(the_label , remove_challenge_subscription_path(:id => user, :challenge => challenge))
	end

end
