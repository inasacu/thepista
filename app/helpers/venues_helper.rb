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

	def get_the_event_day_html(the_day_class, the_day_value, the_color_value, the_color_html)
		return "<div class=\"#{the_day_class}\">
							<div class=\"daybar\"><p>#{the_day_value}</p></div>
							<div class=\"dots\"><ul>#{the_color_value}</ul></div> 
							<div class=\"open\"><ul>#{the_color_html}</ul></div>
						</div>"
	end
	
	# want to create a green dot, you add the class “green” to the list element.
	def get_the_event_dot_color(the_color_class)
		return (the_color_class == nil) ? "" : "<li class=\"#{the_color_class}\"></li>"
	end
	
	# type “lxx” where x is the amount of hours you want the event to be.
	def get_the_event_open_color(the_color_class, the_event_length, the_event_padding, the_event_details)
		return "<li class=\"#{the_color_class} l#{the_event_length} a#{the_event_padding}\"><p>#{the_event_details}</p></li>"
	end
	
	def get_the_event_html(the_venue, the_items, the_reservation_day_numbers, is_same_day, day_of_month_counter, 
		the_current_day_number, is_same_month_year, the_week, is_less_than_day=true)

		the_day_is_today = "day today"
		the_event_length = 1
		the_event_padding = 1
		the_day_class = "day"

		the_event_dot_color = ""
		the_event_open_color = ""

		the_color_class = "green"				# available_true
		# the_color_class = "none"			# available_false
		# the_color_class = "blue"			# subscription__true 
		# the_color_class = "yellow"		# subscription_false
		# the_color_class = "red"				# others 


		# the_colors = ['available_true', 'available_false', 'subscription__true', 'subscription_false', 'others']
		the_colors_used = []

		is_same_day = (day_of_month_counter == the_current_day_number and is_same_month_year) 
		the_day_class = the_day_is_today if is_same_day
		is_same_reservation_date = the_reservation_day_numbers.include?(day_of_month_counter)

		# the_items for this date is found
		if is_same_reservation_date

			the_items.each do |item|
				if (item.starts_at == (convert_to_datetime_zone(@the_day_of_month, item.starts_at)))

					is_subscriber = false			
					the_item = ""

					the_item_name_limit_link = item_name_link(item.name, item, nil, 12)	
				
					case item.class.to_s
					when 'Schedule'
						is_subscriber = item.group.is_subscriber_of?(the_venue)
						the_color_class = "subscription_true"						
					when 'Reservation'
						
						case item.item_type
						when 'User'
							the_color_class = "subscription_false"
							the_item_name_limit_link = item_name_link(item.item)
						when 'Reservation'
							the_color_class = "available_true" 
							
							the_item_name_limit_link =  "#{link_to(label_name(:reservations_new), 
							new_reservation_path(:id => item.installation, :block_token => item.block_token))}"
						end
						
					end
					
					the_item = "#{nice_simple_time_at(item.starts_at)}  #{the_item_name_limit_link}"
					

					the_event_dot_color = "#{the_event_dot_color} #{get_the_event_dot_color(the_color_class)}" unless the_colors_used.include?(the_color_class)
					the_event_open_color = "#{the_event_open_color} #{get_the_event_open_color(the_color_class, the_event_length, the_event_padding, the_item)}"

					the_colors_used << the_color_class unless the_colors_used.include?(the_color_class)
				end
			end

		end


		the_week << get_the_event_day_html(the_day_class, @day_of_month_counter, the_event_dot_color, the_event_open_color)	if is_less_than_day
		@day_of_month_counter+=1	
		@the_day_of_month += 1.day
		is_same_day = false
		the_event_dot_color = ""
		the_event_open_color = ""
		the_day_class = "day"

		return the_day_class, the_event_dot_color, the_event_open_color, the_week
		
	end
		
	def get_month_timetables(the_items, the_holidays, the_day_of_month, the_first_day_of_month, the_last_day_of_month, installation)
		
		all_timetables = []
		the_holiday_day_numbers = []
		the_holidays.each { |item| the_holiday_day_numbers << item.starts_at.day }
		
		the_first_day_of_month..the_last_day_of_month.times.each do |x|	

			# determine if the_day_of_month is a holiday and changes hours to holiday hours
			is_holiday = false
			holiday_hour = true		

			if the_holiday_day_numbers.include?(the_day_of_month.day)
				the_holidays.each do |holiday| 
					if holiday.starts_at == convert_to_datetime_zone(the_day_of_month, holiday.starts_at)
						is_holiday = true
						holiday_hour = holiday.holiday_hour
					end
				end
			end

			# get only timetable associated to specific day of the month and include if holiday
			the_timetables = Timetable.installation_week_day(installation, the_day_of_month, is_holiday)

			the_timetables.each do |item|

				starts_at = convert_to_datetime_zone(the_day_of_month, item.starts_at)
				ends_at = convert_to_datetime_zone(the_day_of_month.midnight, item.ends_at)
				time_frame = item.timeframe.hour			

				while ( starts_at < ends_at )

					reserved = false

					# determine if items (schedules / reservations) should not be available to reserve
					the_items.each do |reservation| 
						if reservation.starts_at == starts_at
							reserved = true
							all_timetables << reservation
						end
					end 

					# reserved = true if (is_holiday and !holiday_hour)

					unless reserved 

						new_reservation = Reservation.new
						new_reservation.name = label_name(:reservation)
						new_reservation.starts_at = starts_at			
						new_reservation.ends_at = starts_at + time_frame
						new_reservation.venue_id = installation.venue.id
						new_reservation.installation_id = installation.id
						new_reservation.block_token = Base64::encode64(starts_at.to_i.to_s)
						new_reservation.available = (starts_at > Time.zone.now + MINUTES_TO_RESERVATION )
						new_reservation.item_type = 'Reservation'
						
						all_timetables << new_reservation if new_reservation.available

					end
					
					starts_at += time_frame	

				end
								
			end

			the_day_of_month += 1.day

		end
		
		return all_timetables
		
	end
		
end

