module MatchesHelper

	def match_roster_change_link(match, type, show_label=true, show_icon=true)    
		# the_schedule = match.schedule
		the_image = IMAGE_CONVOCADO

		the_label = "#{I18n.t(:change_roster_status) } #{I18n.t(type.name).downcase}"
		the_link = show_label ? "" : link_to(the_label, match_status_path(:id => match.id, :type => type.id)) 
		the_break = (show_label ? "" : "<br/>")

		case type.id
		when 1
			the_image = IMAGE_CONVOCADO
		when 2
			the_image = IMAGE_ULTIMA_HORA 
		when 3
			the_image = IMAGE_AUSENTE 
		when 4
			the_image = IMAGE_NO_DISPONIBLE
		end      
		return "#{link_to(image_tag(the_image, :title => the_label, :style => 'height: 16px; width: 16px;'), match_status_path(:id => match.id, :type => type.id), :title => the_label)} #{the_link} #{the_break}".html_safe if show_icon
		return "#{the_link} #{the_break}".html_safe unless show_icon
	end

	def match_roster_link(text, match = nil, html_options = nil)
		if match.nil?
			match = text
			text = match.schedule.name
		elsif match.schedule.is_a?(Hash)
			html_options = match.schedule
			match = text
			text = match.schedule.name
		end

		case match.type_id
		when 1
			return link_to(h(text), team_roster_path(:id => match.schedule), html_options)
		when 2
			return link_to(h(text), team_last_minute_path(:id => match.schedule), html_options)
		when 3
			return link_to(h(text), team_no_show_path(:id => match.schedule), html_options)
		when 4
			return link_to(h(text), team_unavailable_path(:id => match.schedule), html_options)
		end    
	end

	def match_image_link(match, the_image="")   

		the_schedule = match.schedule
		the_label = ""
		the_match_type_label = "#{match.type_name}".downcase.gsub(' ', '_')
		the_label = I18n.t(the_match_type_label) if the_image.blank?

		case match.type_id
		when 1
			the_image = IMAGE_CONVOCADO if the_image.blank?
			return link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), team_roster_path(:id => the_schedule), :title => the_label)
		when 2
			the_image = IMAGE_ULTIMA_HORA if the_image.blank?
			return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_last_minute_path(:id => the_schedule), :title => the_label)
		when 3
			the_image = IMAGE_AUSENTE if the_image.blank?
			return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_no_show_path(:id => the_schedule), :title => the_label)
		when 4
			the_image = IMAGE_NO_DISPONIBLE if the_image.blank?
			return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_unavailable_path(:id => the_schedule), :title => the_label)
		end    
	end

	def match_my_current_link(schedule, match_type, user)

		unless schedule.played?
			my_current_match = ''
			the_match_type = ''	

			schedule.matches.each{|match| my_current_match = match if match.user_id == user.id}
			match_type.each {|type| the_match_type = type if type.id == my_current_match.type_id}		
			the_current_label = "#{I18n.t(:change)} #{I18n.t(:from)} #{I18n.t(the_match_type.name).downcase}"

			the_action = get_the_action.downcase.gsub(' ','_')

			case the_match_type.id
			when 1
				show_link = (the_action == "team_roster")
			when 2
				show_link = (the_action == "team_last_minute")
			when 3
				show_link = (the_action == "team_no_show")
			when 4
				show_link = (the_action == "team unavailable")
			end

			return match_roster_link(the_current_label, my_current_match) unless show_link
		end
	end

	def match_all_my_link(schedule, user, is_manager, show_icon=true)
		match_types = Match.get_match_type
		has_match_date_passed = (schedule.starts_at < LAST_WEEK) or schedule.played?

		unless has_match_date_passed
			my_current_match = nil
			the_match_link = ''
			schedule.matches.each{|match| my_current_match = match if match.user_id == user.id}

			unless my_current_match.nil?
				match_types.each do |type| 
					unless type.id == my_current_match.type_id 	          
						if type.id == 4
							the_match_link = "#{the_match_link} #{match_roster_change_link(my_current_match, type, is_manager)}  "  if is_manager
						else
							the_match_link = "#{the_match_link} #{match_roster_change_link(my_current_match, type, is_manager, show_icon)}  " 
						end
					end
				end
				return the_match_link
			end
		end
	end

	def recent_activities_matches(match_items)
		the_activities = ""
		the_user_matches = []
		total_items = 0
		counter = 0

		match_items.each {|item| total_items += 1}

		match_items.each do |item| 
			counter += 1

			if item.class.to_s == 'Match'

				same_previous_user = false														
				if the_user_matches.empty?
					the_user_matches << item 								
					same_previous_user = true

				else
					# the_match = item
					the_user = item.user
					the_type = item.type_id 
					the_group = item.schedule.group

					the_user_matches.each do |the_match|
						same_previous_user = (the_match.user == the_user and the_match.type_id == the_type and the_match.schedule.group == the_group)
					end

					the_user_matches << item if same_previous_user								
				end

				if (same_previous_user and counter < total_items)
				else
					the_render = 'home/upcoming_matches' if DISPLAY_HAYPISTA_TEMPLATE
					the_render = 'home/upcoming_matches_zurb' unless DISPLAY_HAYPISTA_TEMPLATE

					the_activities = %(#{the_activities.html_safe} #{render(the_render.html_safe, :matches => the_user_matches).html_safe})

					#reset the_user_match and add new match
					the_user_matches = []
					the_user_matches << item
				end																

			else  
				the_render = 'home/upcoming_home' if DISPLAY_HAYPISTA_TEMPLATE
				the_render = 'home/upcoming_home_zurb' unless DISPLAY_HAYPISTA_TEMPLATE

				the_activities = %(#{the_activities.html_safe} #{render(the_render.html_safe, :teammate => item).html_safe})
			end
		end
		return the_activities.html_safe
	end  

	def upcoming_matches(matches)
		the_manager = nil
		request_image = ""
		request_link = ""

		item_link = ""
		item_image = ""

		item_group_link = ""

		the_label = ""
		four_spaces = ".&nbsp;&nbsp;&nbsp;&nbsp;"

		first_icon = ""
		the_icon = ""

		the_match = matches.first

		request_image = item_image_link_small(the_match.user)
		request_link = user_link_limit(the_match.user)

		first_icon = match_image_link(the_match)
		the_icon = match_image_link(the_match, the_match.schedule.sport.icon)

		item_group_link = item_name_link(the_match.schedule.group)

		is_member = is_current_member_of(the_match.schedule.group)


		the_label = %(#{I18n.t(:passed_to)} <STRONG>#{the_match.type_name}</STRONG> #{I18n.t(:in)})

		the_links = ""	
		matches.each do |match|
			the_links = %(#{the_links} #{is_member ? match_roster_link(match) : sanitize(match.schedule.name)}, )
		end

		the_links = %(#{the_links.chop.chop})	
		the_label = %(#{the_label} #{the_links})

		the_color = "green"
		case the_match.type_id
		when 1
			the_color = "green"
		when 2
			the_color = "yellow"
		else
			the_color = "red"
		end

		return request_image, first_icon, request_link, the_label, the_icon, item_group_link, the_match, the_color		
	end

	def set_team_roster_box(the_roster, schedule)
		counter = 0 
		roster_count = (object_counter(the_roster) > 0)

		type_id = [1, 4]

		home = {}
		away = {}
		technical = {}
		physical = {}

		is_manager ||= false
		is_member ||= false
		show_deviation ||= false
		show_mean ||= true

		home["defense"] = 0.0
		home["center"] = 0.0
		home["attack"] = 0.0
		home["technical"] = 0.0
		home["physical"] = 0.0
		home["total"] = 0.0
		home["mean"] = 0.0
		home["deviation"] = 0.0
		home["level"] = 0.0
		home["total_skill"] = 0.0
		home["players"] = 0

		away["defense"] = 0.0
		away["center"] = 0.0
		away["attack"] = 0.0
		away["technical"] = 0.0
		away["physical"] = 0.0
		away["total"] = 0.0
		away["mean"] = 0.0
		away["deviation"] = 0.0
		away["level"] = 0.0
		away["total_skill"] = 0.0
		away["players"] = 0

		group = schedule.group
		is_manager = is_current_manager_of(schedule) ? true : is_current_manager_of(group)
		# is_manager = is_current_manager_of(group) 
		is_member = is_current_member_of(group)

		is_squad = get_the_action.gsub(' ','_') == 'team_roster'
		group_games_played = schedule.group.games_played.to_f

		schedule_number = Schedule.schedule_number(schedule)  

		first_schedule = schedule.group.schedules.first
		has_been_played = schedule.played? 	
		is_sub_manager = !has_been_played
		has_been_played_squad = has_been_played and is_squad

		show_right_border = true
		if is_squad
			show_right_border = true 
		elsif !is_squad
			show_right_border = false unless is_manager
		end

		show_right_evaluation = is_manager
		show_right_evaluation = true if (!is_manager and has_been_played)

		# if DISPLAY_TRUESKILL
		# 	the_trueskill_label = get_cluetip(label_name(:true_skill_mean_initial), 'info', label_name('true_skill_mean_cluetip'))
		# 	the_trueskill_label_final = get_cluetip(label_name(:true_skill_mean_final), 'info', label_name('true_skill_mean_cluetip'))
		# end

		return roster_count, is_squad, has_been_played, show_right_evaluation, is_manager, is_member, home, away, group_games_played, schedule_number, 
		group, has_been_played_squad, show_right_border, show_right_evaluation, show_deviation, show_mean

	end

	def set_team_skill(home, away, is_manager, has_been_played=false)
		home["level"] = home["mean"]
		away["level"] = away["mean"]

		home["total"] = home["technical"].to_f + home["physical"].to_f
		away["total"] = away["technical"].to_f + away["physical"].to_f

		home["technical_difference"] = 0.0
		away["technical_difference"] = 0.0

		home["physical_difference"] =  0.0
		away["physical_difference"] =  0.0

		home["total_difference"] = 0.0
		away["total_difference"] = 0.0	

		home["has_technical_value"] = home["technical"] > 0
		home["has_physical_value"] = home["physical"] > 0
		home["has_total_value"] = home["total"] > 0

		away["has_technical_value"] = away["technical"] > 0
		away["has_physical_value"] = away["physical"] > 0
		away["has_total_value"] = away["total"] > 0

		if home["has_technical_value"] and away["has_technical_value"]
			home["technical_difference"] = (home["technical"] - away["technical"]).to_f / (away["technical"] ) * 100
			away["technical_difference"] = (away["technical"] - home["technical"]).to_f / (home["technical"]) * 100
		end

		if home["has_physical_value"] and away["has_physical_value"]
			home["physical_difference"] = (home["physical"] - away["physical"]).to_f / (away["physical"]) * 100
			away["physical_difference"] = (away["physical"] - home["physical"]).to_f / (home["physical"]) * 100
		end

		if home["has_total_value"] and away["has_total_value"] 		
			home["total_difference"] = (home["total"] - away["total"]).to_f / (away["total"]) * 100
			away["total_difference"] = (away["total"] - home["total"]).to_f / (home["total"]) * 100 
		end

		home["technical_difference"] = "#{sprintf( "%.2f", home["technical_difference"].abs)}%"
		away["technical_difference"] = "#{sprintf( "%.2f", away["technical_difference"].abs)}%"

		home["physical_difference"] = "#{sprintf( "%.2f", home["physical_difference"].abs)}%"
		away["physical_difference"] = "#{sprintf( "%.2f", away["physical_difference"].abs)}%"

		home["total_difference"] = "#{sprintf( "%.2f", home["total_difference"].abs)}%"
		away["total_difference"] = "#{sprintf( "%.2f", away["total_difference"].abs)}%"

		home["is_technical_lower"] = home["technical"] < away["technical"]
		home["is_physical_lower"] = home["physical"] < away["physical"]
		home["is_total_lower"] = home["total"] < away["total"]

		away["is_technical_lower"] = home["technical"] > away["technical"]
		away["is_physical_lower"] = home["physical"] > away["physical"]
		away["is_total_lower"] = home["total"] > away["total"]

		home["technical_difference"] = "-#{home["technical_difference"]}" if home["is_technical_lower"] and !away["is_technical_lower"] 
		away["technical_difference"] = "-#{away["technical_difference"]}" if !home["is_technical_lower"] and away["is_technical_lower"] 

		home["physical_difference"] = "-#{home["physical_difference"]}" if home["is_physical_lower"] and !away["is_physical_lower"] 
		away["physical_difference"] = "-#{away["physical_difference"]}" if !home["is_physical_lower"] and away["is_physical_lower"] 

		home["total_difference"] = "-#{home["total_difference"]}" if home["is_total_lower"] and !away["is_total_lower"] 
		away["total_difference"] = "-#{away["total_difference"]}" if !home["is_total_lower"] and away["is_total_lower"]

		home["image"] = scorecard_image_link(IMAGE_SUBIR_CLASIFICACION) if home["total_difference"] > away["total_difference"]
		home["image"] = scorecard_image_link(IMAGE_BAJAR_CLASIFICACION) if home["total_difference"] < away["total_difference"]
		home["image"] = scorecard_image_link(IMAGE_MANTENER_CLASIFICACION) if home["total_difference"] == away["total_difference"]

		away["image"] = scorecard_image_link(IMAGE_SUBIR_CLASIFICACION) if away["total_difference"] > home["total_difference"]
		away["image"] = scorecard_image_link(IMAGE_BAJAR_CLASIFICACION) if away["total_difference"] < home["total_difference"]
		away["image"] = scorecard_image_link(IMAGE_MANTENER_CLASIFICACION) if away["total_difference"] == home["total_difference"]

		home["technical"] = "" if home["technical"].to_f <= 0 
		away["technical"] = "" if away["technical"].to_f <= 0 

		home["physical"] = "" if home["physical"].to_f <= 0 
		away["physical"] = "" if away["physical"].to_f <= 0  

		home["total"] = "" if home["total"].to_f <= 0 
		away["total"] = "" if away["total"].to_f <= 0

		home["technical_difference"] = "" if home["technical_difference"].to_f <= 0 
		away["technical_difference"] = "" if away["technical_difference"].to_f <= 0 

		home["physical_difference"] = "" if home["physical_difference"].to_f <= 0 
		away["physical_difference"] = "" if away["physical_difference"].to_f <= 0  

		home["total_difference"] = "" if home["total_difference"].to_f <= 0 
		away["total_difference"] = "" if away["total_difference"].to_f <= 0	

		home["level_difference"] = 0.0
		away["level_difference"] = 0.0	

		home["has_level_value"] = home["level"] > 0
		away["has_level_value"] = away["level"] > 0

		if home["has_level_value"] and away["has_level_value"] 		
			home["level_difference"] = (home["level"] - away["level"]).to_f / (away["level"]) * 100
			away["level_difference"] = (away["level"] - home["level"]).to_f / (home["level"]) * 100 
		end

		home["level_difference"] = "#{sprintf( "%.2f", home["level_difference"].abs)}%"
		away["level_difference"] = "#{sprintf( "%.2f", away["level_difference"].abs)}%"

		home["level"] = "#{sprintf( "%.0f", home["level"].abs)}"
		away["level"] = "#{sprintf( "%.0f", away["level"].abs)}"

		home["is_level_lower"] = home["level"] < away["level"]
		away["is_level_lower"] = home["level"] > away["level"]

		home["level_difference"] = "-#{home["level_difference"]}" if home["is_level_lower"] and !away["is_level_lower"] 
		away["level_difference"] = "-#{away["level_difference"]}" if !home["is_level_lower"] and away["is_level_lower"]

		home["level_image"] = scorecard_image_link(IMAGE_SUBIR_CLASIFICACION) if home["level_difference"] > away["level_difference"]
		home["level_image"] = scorecard_image_link(IMAGE_BAJAR_CLASIFICACION) if home["level_difference"] < away["level_difference"]
		home["level_image"] = scorecard_image_link(IMAGE_MANTENER_CLASIFICACION) if home["level_difference"] == away["level_difference"]

		away["level_image"] = scorecard_image_link(IMAGE_SUBIR_CLASIFICACION) if away["level_difference"] > home["level_difference"]
		away["level_image"] = scorecard_image_link(IMAGE_BAJAR_CLASIFICACION) if away["level_difference"] < home["level_difference"]
		away["level_image"] = scorecard_image_link(IMAGE_MANTENER_CLASIFICACION) if away["level_difference"] == home["level_difference"]

		home["level"] = "" if home["level"].to_f <= 0 
		away["level"] = "" if away["level"].to_f <= 0

		home["level_difference"] = "" if home["level_difference"].to_f <= 0 
		away["level_difference"] = "" if away["level_difference"].to_f <= 0	

		show_right_border = true
		if !has_been_played
			show_right_border = false unless is_manager
		end
		return home, away, show_right_border
	end

end

