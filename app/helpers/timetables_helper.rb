module TimetablesHelper

	# def get_the_item_event_day_html(the_day_class, the_day_value, the_color_value, the_color_html)
	# 	return "#{the_day_class}, #{the_day_value}, #{the_color_value}, #{the_color_html}"
	# end

	def get_the_item_event_html(the_venue, the_items, the_reservation_day_numbers, is_same_day, day_of_month_counter, 
		the_current_day_number, is_same_month_year, the_week, is_less_than_day=true)

		the_day_is_today = "day today"
		the_event_length = 1
		the_event_padding = 1
		the_day_class = "day"

		the_event_dot_color = ""
		the_event_open_color = ""

		the_color_class = "green"				# available_true

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

					# case item.class.to_s
					# when 'Schedule'
					# 	is_subscriber = true # item.group.is_subscriber_of?(the_venue)
					# 	the_color_class = "subscription_true"						
					# when 'Reservation'

						# case item.item_type
						# when 'User'
						# 	the_color_class = "subscription_false"
						# 	the_item_name_limit_link = item_name_link(item.item)
						# when 'Reservation'
							the_color_class = "available_true" 

							the_item_name_limit_link =  "#{link_to(label_name(:reservations_new), 
							new_schedule_path(:id => item, :block_token => item.block_token))}"
						# end

					# end

					the_item = "#{nice_simple_time_at(item.starts_at)}  #{the_item_name_limit_link}"

					the_event_dot_color = "#{the_event_dot_color} #{get_the_event_dot_color(the_color_class)}" unless the_colors_used.include?(the_color_class)
					the_event_open_color = "#{the_event_open_color} #{get_the_event_open_color(the_color_class, the_event_length, the_event_padding, the_item)}"

					the_colors_used << the_color_class unless the_colors_used.include?(the_color_class)
				end
			end

		end


		the_week << get_the_item_event_day_html(the_day_class, @day_of_month_counter, the_event_dot_color, the_event_open_color)	if is_less_than_day
		@day_of_month_counter += 1	
		@the_day_of_month += 1.day
		is_same_day = false
		the_event_dot_color = ""
		the_event_open_color = ""
		the_day_class = "day"

		return the_day_class, the_event_dot_color, the_event_open_color, the_week

	end

	def get_item_month_timetables(the_items, the_holidays, the_day_of_month, the_first_day_of_month, the_last_day_of_month, the_item, jornada=1)

		all_timetables = []
		the_holiday_day_numbers = []
		the_match_type_name = Type.find(3).name
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
			the_timetables = Timetable.item_week_day(the_item, the_day_of_month, is_holiday)

			
			the_timetables.each do |item|

				starts_at = convert_to_datetime_zone(the_day_of_month, item.starts_at)
				ends_at = convert_to_datetime_zone(the_day_of_month.midnight, item.ends_at)
				time_frame = item.timeframe.hour			

				while ( starts_at < ends_at )

					reserved = false
					the_items.each do |the_item| 
						if the_item.starts_at == starts_at
							reserved = true
							all_timetables << the_item
						end
					end 

					reserved = true if (is_holiday and !holiday_hour)

					unless reserved 

						new_schedule = Schedule.new
						new_schedule.id = the_item.id
						new_schedule.jornada = jornada 
						new_schedule.name = "#{I18n.t(:jornada)} #{new_schedule.jornada}"
						new_schedule.starts_at = starts_at			
						new_schedule.ends_at = starts_at + time_frame
						new_schedule.block_token = Base64::encode64(starts_at.to_i.to_s)
						new_schedule.available = (starts_at > Time.zone.now + MINUTES_TO_RESERVATION )
						new_schedule.item_id = the_item.id
						new_schedule.item_type = the_item.class.to_s
						new_schedule.group_name = the_item.name
						new_schedule.group_id = the_item.id
						new_schedule.sport_id = the_item.sport_id
						new_schedule.marker_id = the_item.marker_id
						new_schedule.time_zone = the_item.time_zone
						new_schedule.player_limit = the_item.player_limit
						new_schedule.fee_per_game = 1
						new_schedule.fee_per_pista = 1
						new_schedule.fee_per_pista = the_item.player_limit * new_schedule.fee_per_game if the_item.player_limit > 0
						new_schedule.reminder_at = new_schedule.starts_at - 2.days
						new_schedule.season = Time.zone.now.year
						new_schedule.played = false
						new_schedule.timeframe = time_frame
						new_schedule.ismock = true
						
						
						
						if Match.schedule_user_exists?(new_schedule, current_user)

							new_schedule.match_status_at = Time.zone.now
							new_schedule.match_group_id = new_schedule.group_id
							new_schedule.match_user_id = current_user.id
							new_schedule.match_type_id = 3
							new_schedule.match_type_name = the_match_type_name
							new_schedule.match_played = false
							
						end
			
						
						all_timetables << new_schedule if new_schedule.available
						jornada += 1

					end

					starts_at += time_frame	

				end

			end

			the_day_of_month += 1.day

		end

		return all_timetables

	end
	
end
