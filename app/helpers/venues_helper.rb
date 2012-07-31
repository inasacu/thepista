module VenuesHelper

	def venue_show_photo(venue, current_user)
		if venue.photo_file_name
			return item_image_link_large(venue)
		end
		if is_current_manager_of(venue)
			"#{I18n.t(:no_photo_for, get_the_controller)}.  #{link_to(I18n.t(:upload), edit_venue_path(venue))}"
		else  
			return item_image_link_large(venue)
		end
	end	

	def venue_avatar_image_link(venue)
		link_to(image_tag(IMAGE_VENUE, options={:style => "height: 15px; width: 15px;"}), venue_path(venue)) 
	end

	def venue_vs_invite(schedule)
		item_name_link(schedule.venue)  
	end

	def venue_score_link(schedule)
		return "#{schedule.home_venue} ( #{schedule.home_score}  -  #{schedule.away_score} ) #{schedule.away_venue}" 
	end    

	def venue_list(objects)
		return item_list(objects)
	end

	def set_role_venue_add_sub_manager(user, venue)
		the_label = label_with_name('role_add_sub_manager', h(venue.name))  
		link_to(the_label , set_sub_manager_path(:id => user, :venue => venue))
	end

	def set_role_venue_remove_sub_manager(user, venue)
		the_label = label_with_name('role_remove_sub_manager', h(venue.name))   
		link_to(the_label , remove_sub_manager_path(:id => user, :venue => venue))
	end

	def set_role_venue_add_subscription(user, venue)
		the_label = label_with_name('role_add_subscription', h(venue.name)) 
		link_to(the_label , set_subscription_path(:id => user, :venue => venue))
	end

	def set_role_venue_remove_subscription(user, venue)
		the_label = label_with_name('role_remove_subscription', h(venue.name))
		link_to(the_label , remove_subscription_path(:id => user, :venue => venue))
	end

	def get_the_blankday_html(the_day_value)
		return "<div class=\"day\">
							<div class=\"daybar\"><p>#{the_day_value}</p></div>
							<div class=\"dots\"><ul></ul></div> 
							<!-- slide open -->
							<div class=\"open\"><ul></ul></div> 
							<!-- slide close -->
						</div>"
	end

	def get_the_today_big_html(the_day_value)
		return "<div class=\"day today big\">
							<div class=\"daybar\"><p>#{the_day_value}</p></div>
							<div class=\"dots\"><ul></ul></div> 
							<!-- slide open -->
							<div class=\"open\"><ul></ul></div> 
							<!-- slide close -->
						</div>"
	end

	# get_the_event_day_html(the_day_value, get_the_event_dot_color(the_color_class), get_the_event_open_color(the_color_class, the_event_length, the_event_padding, the_event_details))

	def get_the_event_day_html(the_day_class, the_day_value, the_color_value, the_color_html)
		return "<div class=\"#{the_day_class}\">
							<div class=\"daybar\"><p>#{the_day_value}</p></div>
							<div class=\"dots\"><ul>#{the_color_value}</ul></div> 
							<div class=\"open\"><ul>#{the_color_html}</ul></div>
						</div>"
	end
	
	# want to create a green dot, you add the class “green” to the list element.
	def get_the_event_dot_color(the_color_class)
		return "<li class=\"#{the_color_class}\"></li>"
	end
	
	# type “lxx” where x is the amount of hours you want the event to be.
	def get_the_event_open_color(the_color_class, the_event_length, the_event_padding, the_event_details)
		return "<li class=\"#{the_color_class} l#{the_event_length} a#{the_event_padding}\"><p>#{the_event_details}</p></li>"
	end
		
end

