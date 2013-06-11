module FlashHelper

	def get_flash_details
		the_controller = get_the_controller
		the_tab_navigation = "#{the_controller}s"
		the_title = nil
		the_label_title = label_name("#{the_controller}s")



		is_new_item = (is_action('new') or is_action('create'))
		@new_item = nil	

		case the_controller
		when 'announcement'
			@new_item = @announcement if is_new_item

		when 'home'
			the_tab_navigation = "#{get_the_controller}"

		when 'match'
			the_tab_navigation = "schedules"

		when 'fee', 'payment', 'classified'
			the_tab_navigation = "users" if @user
			the_tab_navigation = "groups" if @group
			the_tab_navigation = "challenges" if @challenge
			the_tab_navigation = "venues" if @venue

		when 'scorecard'
			the_tab_navigation = "groups"

		when 'invitation'
			the_tab_navigation = 'messages'
			@new_item = @invitation if is_new_item

		when 'escuadra'
			the_tab_navigation = 'cups'
			the_title = the_controller 

		when 'cup'
			the_tab_navigation = 'cups'
			the_title = the_controller
			@new_item = @cup if is_new_item

		when 'game'
			the_tab_navigation = 'cups'
			the_title = the_controller

		when 'standing'
			the_tab_navigation = 'cups'
			the_title = the_controller

		when 'challenge'
			the_tab_navigation = 'challenges'
			@new_item = @challenge if is_new_item 

		when 'cast'
			the_tab_navigation = 'challenges'

		when 'enchufado'
			the_title = the_controller
			@new_item = @enchufado if is_new_item

		when 'subplug'
			the_tab_navigation = "enchufados"

		when 'company'
			the_title = the_controller
			@new_item = @company if is_new_item
			the_tab_navigation = "companies"
			the_label_title = label_name("companies")

		when 'branch'
			the_tab_navigation = "companies"
			# the_tab_navigation = "branches"
			the_label_title = label_name("branches")

		when 'group'
			the_title = the_controller
			@new_item = @group if is_new_item

		when 'schedule'
			@new_item = @schedule if is_new_item
			the_tab_navigation = "schedules" if is_action('index') or is_action('list')
			the_tab_navigation = "groups" if get_controller_action == 'schedule_group_previou' or get_controller_action == 'schedule_group_current'

		when 'venue'
			@new_item = @venue if is_new_item

		when 'installation'
			the_tab_navigation = "venues"

		when 'reservation'
			the_tab_navigation = "venues"

		when 'prospect'
			the_tab_navigation = "prospects"

		when 'message'
			the_tab_navigation = 'messages'
			the_title = the_controller
			is_display_title = false
			@new_item = @message if is_new_item

		when 'user session', 'authentication', 'enchufado', 'timetable'
			the_tab_navigation = nil		
		end	

		the_tab_navigation = 'challenges' if get_controller_action == 'standing_show_list'
		the_tab_navigation = 'cups' if get_controller_action == 'cast_list_gues'

		password_reset_actions = ['password_reset_new', 'password_reset_edit', 'password_reset_update']
		is_password_reset = password_reset_actions.include?(get_controller_action)
		is_new_user = @user ? true : false
		the_label = label_name(:users_rpx_new) 
		@item = @user

		ignore_label_fill_in_fields = ['user_omniauth_new']
		is_ignore_label_fill = ignore_label_fill_in_fields.include?(get_controller_action)

		return is_new_user, is_password_reset, is_ignore_label_fill, @new_item, the_tab_navigation, the_label_title, is_display_title 
	end
	
end 