class HomeController < ApplicationController  
	before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, 
								:openid, :success, :blog, :persona, :feedback, :qr, :how_it_works]

	before_filter :get_home,            :only => [:index]
	before_filter :get_upcoming,        :only => [:index, :upcoming]

	def privacy_policy
		set_the_template('home/terms_of_use')
	end

	def search
		@item_results = []
		@all_items =  Search.new(params[:search])
		@all_items[0..LARGE_FEED_SIZE].each {|item| @item_results << item }
		render @the_template   
	end

	private

	def get_upcoming 
		store_location

		@upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
		@upcoming_cups ||= Cup.upcoming_cups(session[:cup_hide_time])
		@upcoming_games ||= Game.upcoming_games(session[:game_hide_time])

		@upcoming ||=  false
		@upcoming = (!@upcoming_schedules.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
	end

	def get_home
		@items = []
		@all_items = []  
		@all_values = []
		@match_items = []
		@all_match_items = []    
		@schedule_items = []
		@all_schedule_items = []    
		@my_schedules = []    
		@requested_teammates = []    
		@all_comment_items = []
		@comment_items = []

		Teammate.latest_teammates(@all_items) 
		Schedule.latest_matches(@all_items) if @all_items.count < MEDIUM_FEED_SIZE 
		Schedule.latest_items(@all_schedule_items)   

		if current_user      
			@my_schedules = Schedule.my_current_schedules(current_user)
			
			if @my_schedules.empty?
				@my_schedules = Schedule.other_current_schedules(current_user)
			end

			Match.latest_items(@all_match_items, current_user)
			Match.last_minute_items(@all_match_items, current_user) if DISPLAY_LAST_MINUTE_CANCEL

			Teammate.my_groups_petitions(@requested_teammates, current_user)
	
			current_user.groups.each {|group| Scorecard.latest_items(@all_items, group)} if DISPLAY_MAX_GAMES_PLAYED   
		end

		User.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE
		# Group.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE   
		# Group.latest_updates(@all_items) if @all_items.count < MEDIUM_FEED_SIZE     
		# User.latest_updates(@all_items) if @all_items.count < MEDIUM_FEED_SIZE

		Group.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE
		Venue.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE  						if DISPLAY_PROFESSIONAL_SERVICES
		Reservation.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE  			if DISPLAY_PROFESSIONAL_SERVICES

		has_values = false   
		Cup.latest_items(@all_values, has_values)    
		if @all_values.count > 0
			Cup.latest_items(@all_items, has_values)
			Game.latest_items(@all_items)
			
			# DO NOT REMOVE - IMPORTANT FOR OFFICIAL CUPS
			#   Teammate.my_challenges_petitions(@requested_teammates, current_user)   
			# 	Challenge.latest_items(@all_items)
			# 	Cast.latest_items(@all_items)
			
		end     

		@all_items = @all_items.sort_by(&:created_at).reverse!    
		@all_items[0..MEDIUM_FEED_SIZE].each {|item| @items << item }

		@all_schedule_items = @all_schedule_items.sort_by(&:created_at).reverse!    
		@all_schedule_items[0..MEDIUM_FEED_SIZE].each {|item| @schedule_items << item }

		@all_match_items = @all_match_items.sort_by(&:created_at).reverse!    
		@all_match_items[0..EXTENDED_FEED_SIZE].each {|item| @match_items << item }

	end

end