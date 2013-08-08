module SidebarHelper
	
	def get_sidebar_schedule_details
		is_schedule_manager = @schedule ? is_current_manager_of(@schedule.group) : false 
		is_new_schedule = (get_controller_action =='schedule_new' or get_controller_action == 'schedule_create')
	
		return is_schedule_manager, is_new_schedule
	end
	
	def get_sidebar_schedule_show_details
		has_been_played = @schedule.played?

		is_group_manager = @group ? is_current_manager_of(@group) : false
		is_group_member = @group ? is_current_member_of(@group) : false
		has_group = @group ? true : false

		the_group_name = ""
		# the_manager_label = ""
		the_confirmation = ""
		the_label ||= label_name(:options)

		# is_manager_not_forum = (is_group_manager and !is_controller('forum'))
		is_not_topic_not_played = (get_the_controller != 'topic' and !@schedule.played?)

		if has_group
			the_group_name = h(@group.name) 

			has_schedule_blank = @group.schedules.blank? 
			has_user_petition = has_current_item_petition(@group) 
			the_confirmation = label_with_name(:do_leave_item, "#{@group.name}?")

			the_confirmation = "#{ label_name(:destroy_schedule) } #{ label_name(:from) } #{@group.name}?" 

		end
		
		return has_group, is_group_member, has_been_played, has_schedule_blank, is_group_manager
	end
	
	def get_sidebar_venue_details
		is_venue_manager = @venue ? is_current_manager_of(@venue) : false
		is_venue_member = @venue ? is_current_member_of(@venue) : false
		is_new_venue = (get_controller_action =='venue_new' or get_controller_action == 'venue_create')
		has_venue = @venue ? is_new_venue ? false : true : false

		the_label = label_name(:reservation)

		the_venue_name = ""
		the_manager_label = ""
		the_confirmation = ""	

		if has_venue
			the_venue_name = h(@venue.name) 
			the_manager_label = label_name(:options_for_manager)
			the_confirmation = "#{ label_name(:destroy_venue) } #{the_venue_name}?"

			has_schedule_blank = @venue.installations.blank? 
			has_user_petition = has_current_item_petition(@venue) 
			the_confirmation = label_with_name(:do_leave_item, "#{@venue.name}?")
		end
		
		return has_venue, the_label, is_venue_manager
	end
	
	
	def get_sidebar_cup_details
		is_official = @cup.official
		final_played ||= false
		the_game = Game.final_game(@cup)
		final_played = the_game.played unless (the_game.nil? or the_game.blank?)

		the_cup = h(@cup.name)
		the_label = label_with_name('create_game', @cup.name)
		the_confirmation = "#{ label_name(:cups_destroy) } #{the_cup}" 
		has_escuadras = (object_counter(@cup.escuadras) > 0)

		final_played ||= false
		the_game = Game.final_game(@cup)
		final_played = the_game.played unless (the_game.nil? or the_game.blank?)
		
		return has_escuadras, final_played
	end
	
	def get_sidebar_group_details
		is_group_manager = @group ? is_current_manager_of(@group) : false
		is_group_branch_manager = @branch ? is_current_manager_of(@branch.company) : false
		is_group_member = @group ? is_current_member_of(@group) : false
		is_new_group = (get_controller_action =='group_new' or get_controller_action == 'group_create')
		has_group = @group ? is_new_group ? false : true : false

		the_group_name = ""
		the_manager_label = ""
		the_confirmation = ""	

		if has_group
			the_group_name = h(@group.name) 
			the_manager_label = label_name(:options_for_manager)
			the_confirmation = "#{ label_name(:destroy_group) } #{the_group_name}?"

			has_schedule_blank = @group.schedules.blank? 
			has_user_petition = has_current_item_petition(@group) 
			the_confirmation = label_with_name(:do_leave_item, "#{@group.name}?")
		end
		
		return has_group, is_group_member, is_group_manager, is_group_branch_manager
	end
	
end