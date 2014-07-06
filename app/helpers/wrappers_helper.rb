module WrappersHelper

	def get_wrapper_details
		# login options
		login_action = ['signup', 'create', 'new', 'rpx_create', 'rpx_new'] 
		login_controller =['user_sessions', 'users', ''] 
		login_session = (login_controller.include?(controller.controller_name) and login_action.include?(controller.action_name)) 
		logout =  !current_user and is_controller('home') and is_action('index') 

		the_controller = get_the_controller
		the_sidebar = "#{the_controller}s"
		the_sidebar_label = label_name(:options)
		new_item_sidebar = nil

		is_controller_index = is_action('index')

		case the_controller
		when 'home'
			the_sidebar = "#{get_the_controller}"
			the_sidebar_label = label_name(:get_up_and_running)

		when 'match'
			the_sidebar = "schedules"

		when 'fee', 'payment'
			the_sidebar = "users" if @user
			the_sidebar = "groups" if @group
			the_sidebar = "challenges" if @challenge
			the_sidebar = "venues" if @venue

		when 'scorecard'	
      the_sidebar = "groups"	
      ignore_option = ['scorecard_show']
      the_sidebar = nil if ignore_option.include?(get_controller_action)

		when 'invitation'
			the_sidebar = 'messages'	

		when 'escuadra'
			the_sidebar = 'cups'

		when 'standing'
			the_sidebar = 'cups'
			the_sidebar = 'challenges' if get_controller_action == 'standing_show_list'

		when 'cast'
			the_sidebar = 'challenges'
			the_sidebar = 'cups' if get_controller_action == 'cast_list_gues'

		when 'game'
			the_sidebar = nil		
			the_sidebar = 'cups' if get_controller_action == 'game_index' or get_controller_action == 'game_list'

		when 'message'
			new_item_sidebar = Message.new

		when 'cup'
			new_item_sidebar = Cup.new	
			the_sidebar = 'cups' if is_controller_action('cup_index')

		when 'company'
			ignore_option = ['company_show']
			new_item_sidebar = Company.new unless ignore_option.include?(get_controller_action)
			the_sidebar = "companies" 
			
			if @company
				the_sidebar = nil unless is_current_manager_of(@company) 
			end					

		when 'branch'
			the_sidebar = 'groups'

		when 'group'
			ignore_option = ['group_show', 'group_team_list']
			new_item_sidebar = Group.new unless ignore_option.include?(get_controller_action)

		when 'schedule'
			ignore_option = ['schedule_show', 'schedule_team_roster', 'schedule_team_no_show', 'schedule_team_last_minute', 'schedule_team_unavailable']
			new_item_sidebar = Schedule.new unless ignore_option.include?(get_controller_action)

		when 'venue'	
			if the_maximo
				ignore_option = ['venue_show']
				new_item_sidebar = Venue.new unless ignore_option.include?(get_controller_action)
			else
				the_sidebar = nil
			end

		when 'customer'	
			the_sidebar = "customers"
			new_item_sidebar = Customer.new

		when 'survey'	
			the_sidebar = "surveys"
			new_item_sidebar = Survey.new


		end

		ignore_sidebar = ['new','create', 'edit', 'update']
		the_sidebar = nil if ignore_sidebar.include?(get_the_action)

		if get_controller_action == 'group_list' or get_controller_action == 'group_index'
			@the_collection = @groups if @groups
		end

		if get_controller_action == 'schedule_list' or get_controller_action == 'schedule_index' or get_controller_action == 'schedule_group_current' or get_controller_action == 'schedule_group_previou'
			@the_collection = @schedules if @schedules
		end

		if get_controller_action == 'cup_index'
			@the_collection = @cups if @cups
		end

		if get_controller_action == 'escuadra_index'
			@the_collection = @escuadras if @escuadras
		end	

		if get_controller_action == 'game_index'
			@the_collection = @games if @games
		end	

		if get_controller_action == 'prospect_index'
			@the_collection = @prospects if @prospects
		end

		if get_controller_action == 'message_index'
			@the_collection = @messages if @messages
		end

		if get_controller_action == 'venue_index'
			@the_collection = @venues if @venues
		end

		the_controller_action = ['cast_index', 'challenge_challenge_list','cast_list', 'cast_list_guess_user', 'cast_list_gues']
		if the_controller_action.include?(get_controller_action)
			@the_collection = @casts if @casts
		end

		# case for discard displaying DISQUS
		discard_disqus_display = ['group_new', 'group_edit', 'schedule_new', 'schedule_edit', 'cast_edit', 'match_edit', 'invitation_new', 'challenge_new', 'challenge_edit', 'message_new']

		# display full screen or partial
		the_twelve_columns = ['reservation_index']

		# case for displaying SIDEBAR 
		ignore_sidebar = ['schedule_list', 'user_index', 'user_list', 'invitation_new', 'challenge_new', 'challenge_create', 
			'message_show', 'message_new', 'game_index', 'standing_index',
			'game_list','cast_list_gues','standing_show_all', 'standing_show', 'reservation_index', 
			'user_session_new', 'authentication_index', 'schedule_group_previou', 'schedule_group_current']

		IGNORE_HOME.each  do |the_ignore| 
			ignore_sidebar << the_ignore 
			the_twelve_columns << the_ignore
		end

		the_sidebar = nil if ignore_sidebar.include?(get_controller_action)
		the_column_set = the_twelve_columns.include?(get_controller_action) ? "twelve columns" : nil
		
		return the_column_set, discard_disqus_display, the_sidebar, the_sidebar_label, new_item_sidebar
	end
	
end
