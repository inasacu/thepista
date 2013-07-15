module TabsHelper

	def set_tab_navigation(the_label)
		return content_tag(:dd, the_label) 
	end

	def set_tab_navigation_active(controller_action)
		return :class => get_active(controller_action)
	end

	# <%= set_content_tag_dd(:upcoming, upcoming_path, 'home_upcoming') %>
	def set_content_tag_dd(item_label, the_link, the_tab=nil, unique_label=false)
		the_label = item_label.to_s
		the_label = label_name( :"#{item_label}") unless unique_label
		return content_tag :dd, link_to(the_label, the_link, :class => get_active(the_tab.nil? ? nil : the_tab)) unless is_mobile_browser
		return content_tag :dd, link_to(the_label, the_link), :class => get_active(the_tab.nil? ? nil : the_tab) 
	end
	
		def get_schedule_tab_details
		the_label = "" 
		the_action = ['show','edit', 'team list', 'schedule list', 'group current list', 'group previous list', 'list']
		the_controller = ['classified', 'fee', 'payment', 'schedule']

		single_schedule_group = @schedule and @schedule.group
		content_for(:description, "#{@schedule.group.name} / #{@schedule.group.sport.name},  #{@schedule.group.description}.  #{@schedule.group.marker.name}, #{@schedule.group.time_zone}") if single_schedule_group

		the_controller = ['match']
		the_action = ['show', 'edit', 'team roster', 'team no show', 'team last minute', 'team unavailable', 'star rate']


		is_the_roster = false
		is_last_minute = false
		is_no_show = false

		if @schedule
			is_the_roster = @schedule.the_roster.empty?
			is_last_minute = @schedule.the_last_minute.empty?
			is_no_show = @schedule.the_no_show.empty?


			unless is_the_roster		
				the_label_roster = "#{label_name(:rosters)} (#{@schedule.the_roster_count})"
				the_tab_roster = "#{get_the_controller}_team_roster"
			end

			unless is_last_minute		
				the_label_last_minute = "#{label_name(:last_minute)} (#{@schedule.the_last_minute_count})"
				the_tab_last_minute = "#{get_the_controller}_team_last_minute"
			end

			unless is_no_show		
				the_label_no_show = "#{label_name(:no_shows)} (#{@schedule.the_no_show_count})"
				the_tab_no_show = "#{get_the_controller}_team_no_show"
			end	
		end
		
		return the_action, the_controller, the_label_roster, the_tab_roster, is_the_roster, the_label_last_minute, the_tab_last_minute, is_last_minute, the_label_no_show, the_tab_no_show, is_no_show		
	end

end