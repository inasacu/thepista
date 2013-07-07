class SchedulesController < ApplicationController
	before_filter :require_user

	before_filter :get_schedule, :only => [:show, :rate, :edit, :update, :destroy, :set_public, :set_reminder, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
	before_filter :get_current_schedule, :only => [:index, :list, :my_list]
	before_filter :get_group, :only => [:new, :schedule_list, :group_current, :group_previous]
	before_filter :get_match_type, :only => [:team_roster, :team_last_minute, :team_no_show, :team_unavailable]
	before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_public, :set_reminder]
	before_filter :has_member_access, :only => [:show, :rate]
	before_filter :excess_players, :only => [:show, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
	before_filter :get_user, :only => [:my_list]

	def index
		store_location
		if @has_no_schedules
			redirect_to :action => 'list'
			return
		end
		render @the_template
	end

	def group_current
		@schedules = Schedule.group_current_schedules(@group, params[:page])
		set_the_template('schedules/index')
		render @the_template
	end

	def group_previous
		@schedules = Schedule.group_previous_schedules(@group, params[:page])
		set_the_template('schedules/index')
		render @the_template
	end

	def list
		@schedules = Schedule.previous_schedules(current_user, params[:page])
		set_the_template('schedules/index')
		render @the_template      
	end

	def my_list
		@schedules = Schedule.find_all_played(@user, params[:page])
		set_the_template('schedules/index')
		render @the_template     
	end

	def schedule_list
		@schedules = @group.schedules.page(params[:page])
		set_the_template('schedules/index')
		render @the_template
	end

	def archive_list 
		@schedules = Schedule.current_schedules(current_user, params[:page])
		set_the_template('schedules/index')
		render @the_template
	end

	def show
		store_location    
		render @the_template
	end

	def team_roster
		store_location
				
		@the_roster = nil
		@has_a_roster = nil
		@the_roster_infringe = nil
		@the_roster_last_minute_infringe = nil
		@the_last_played = nil
		# @the_roster_reputation = nil
		
		# @has_a_roster = !(@schedule.convocados.empty?)
		@the_roster = @schedule.the_roster_sort(sort_order(''))
		@has_a_roster = !(@the_roster.empty?)
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		# @the_roster_reputation = @schedule.the_roster_reputation(@group)
		
		set_the_template('schedules/team_roster')
		render @the_template 
	end

	def team_last_minute
		store_location
		@has_a_roster = !(@schedule.last_minute.empty?)
		@the_roster = @schedule.the_last_minute
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		# @the_roster_reputation = @schedule.the_roster_reputation(@group)
		
		set_the_template('schedules/team_roster')
		render @the_template 
	end

	def team_no_show
		store_location
		@has_a_roster = !(@schedule.no_shows.empty?)
		@the_roster = @schedule.the_no_show
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		# @the_roster_reputation = @schedule.the_roster_reputation(@group)
		
		set_the_template('schedules/team_roster')
		render @the_template 
	end

	def team_unavailable
		store_location
		@has_a_roster = !(@schedule.the_unavailable.empty?)
		@the_roster = @schedule.the_unavailable
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		# @the_roster_reputation = @schedule.the_roster_reputation(@group)
		
		set_the_template('schedules/team_roster')
		render @the_template 
	end

	def new

		if @group.is_branch?
				block_token = Base64::decode64(params[:block_token].to_s).to_i
				time_frame = 1.hour

				@first_day = Time.zone.at(block_token)	
				@last_day = @first_day + time_frame
				@first_schedule = Schedule.get_schedule_item_first_to_last_month(@first_day, @last_day, @group.item)

				if @first_schedule.count > 0
					Match.create_item_schedule_match(@first_schedule.first, current_user)
					redirect_to @first_schedule
					return
				end
				
		else
			unless is_current_manager_of(@group)
				notice_to_create_group
				redirect_to groups_url
				return
			end
		end

		@schedule = Schedule.new

		if @group 
			@schedule.jornada = 1
			@schedule.name = "#{I18n.t(:jornada)} #{@schedule.jornada}"
			@schedule.group_id = @group.id
			@schedule.sport_id = @group.sport_id
			@schedule.marker_id = @group.marker_id
			@schedule.time_zone = @group.time_zone
			@schedule.player_limit = @group.player_limit
			@schedule.fee_per_game = 1
			@schedule.fee_per_pista = 1
			@schedule.fee_per_pista = @group.player_limit * @schedule.fee_per_game if @group.player_limit > 0
			@schedule.starts_at = Time.zone.now.change(:hour => 12, :min => 0, :sec => 0) + 1.days
			@schedule.ends_at = @schedule.starts_at + 1.hour
			@schedule.reminder_at = @schedule.starts_at - 2.days
			@schedule.season = Time.zone.now.year
		end
	

		@previous_schedule = Schedule.find(:first, :conditions => ["schedules.group_id = ?", @group.id], :order => "schedules.starts_at DESC")    
		unless @previous_schedule.nil?

			is_current_date = @previous_schedule.starts_at + 1.days > Time.zone.now

			@schedule.jornada = @previous_schedule.jornada + 1
			@schedule.name = "#{I18n.t(:jornada)} #{@schedule.jornada}"

			@schedule.season = @previous_schedule.season
			@schedule.fee_per_game = @previous_schedule.fee_per_game
			@schedule.fee_per_pista = @previous_schedule.fee_per_pista
			@schedule.player_limit = @previous_schedule.player_limit
			@schedule.public = @previous_schedule.public

			if is_current_date
				@schedule.starts_at = @previous_schedule.starts_at + 1.days
				@schedule.ends_at = @previous_schedule.ends_at + 1.days 
			end

			@schedule.reminder_at = @previous_schedule.starts_at - 1.days

			if @schedule.starts_at < Time.zone.now
				@schedule.starts_at = @schedule.starts_at + 7.days
				@schedule.ends_at = @schedule.starts_at + 1.hour
				@schedule.reminder_at = @schedule.starts_at - 2.days
			end

		end
		
		
		if @group.is_branch?
			block_token = Base64::decode64(params[:block_token].to_s).to_i
			time_frame = 1.hour
			
			@schedule.jornada = 1 if @schedule.jornada.nil?
			@schedule.name = "#{I18n.t(:jornada)} #{@schedule.jornada}"
			@schedule.starts_at = Time.zone.at(block_token)	
			@schedule.ends_at = @schedule.starts_at + time_frame 
			@schedule.block_token = Base64::encode64(@schedule.starts_at.to_i.to_s)
			@schedule.group_name = @group.name
			@schedule.group_id = @group.id
			@schedule.player_limit = @group.player_limit
		end		
		
	end

	def create
		@schedule = Schedule.new(params[:schedule])   		
		@schedule.ends_at_date = @schedule.starts_at_date 
		@group = Group.find(@schedule.group_id)
		
		if @group.is_branch?			
			
				block_token = Base64::decode64(@schedule.block_token.to_s).to_i
				time_frame = 1.hour

				@schedule.name = "#{I18n.t(:jornada)} #{@schedule.jornada}"
				@schedule.starts_at = Time.zone.at(block_token)	
				@schedule.ends_at = @schedule.starts_at + time_frame 
				@schedule.reminder_at = @schedule.starts_at - 2.days	
				@schedule.available = (@schedule.starts_at > Time.zone.now + MINUTES_TO_RESERVATION )
				@schedule.item_id = @group.id
				@schedule.item_type = @group.class.to_s
				@schedule.group_name = @group.name
				@schedule.group_id = @group.id
				@schedule.sport_id = @group.sport_id
				@schedule.marker_id = @group.marker_id
				@schedule.time_zone = @group.time_zone
				@schedule.player_limit = @group.player_limit
				@schedule.fee_per_game = 1
				@schedule.fee_per_pista = 1
				@schedule.fee_per_pista = @group.player_limit * @schedule.fee_per_game if @group.player_limit > 0
				@schedule.reminder_at = @schedule.starts_at - 2.days
				@schedule.season = Time.zone.now.year
				
				@previous_schedule = Schedule.find(:first, :conditions => ["schedules.group_id = ?", @group.id], :order => "schedules.starts_at DESC")    
				unless @previous_schedule.nil?
					@schedule.jornada = @previous_schedule.jornada + 1
					@schedule.name = "#{I18n.t(:jornada)} #{@schedule.jornada}"
				end
			
		else
			unless is_current_manager_of(@group)
				warning_unauthorized
				redirect_back_or_default('/index')
				return
			end
		end

		if @schedule.save and @schedule.create_schedule_roles(current_user)

			if @schedule.group.is_branch?
				Match.create_item_schedule_match(@schedule, current_user)
			else
				@schedule.create_schedule_details
				Schedule.delay.send_created
			end

			successful_create
			redirect_to @schedule
		else
			render :action => 'new'
		end
	end


	def edit
		set_the_template('schedules/new')
	end

	def update
		if @schedule.update_attributes(params[:schedule]) 
			@schedule.delay.create_schedule_details
			controller_successful_update
			redirect_to @schedule
		else
			render :action => 'edit'
		end
	end

	def destroy
		@schedule.played = false
		@schedule.save
		@schedule.matches.each do |match|
			match.archive = false
			match.save!
		end
		Scorecard.delay.calculate_group_scorecard(@schedule.group)
		@schedule.destroy

		flash[:notice] = I18n.t(:successful_destroy)
		redirect_to :action => 'index'  
	end

	def set_reminder
		if @schedule.update_attribute("reminder", !@schedule.reminder)
			@schedule.update_attribute("reminder", @schedule.reminder)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end


	def set_roster_position_name
		@match = Match.find(params[:id])
		unless is_current_manager_of(@match.schedule.group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
		@type = Type.find(params[:roster][:position_name])
		if @match.update_attributes('position_id' => @type.id)
			controller_successful_update
		end
		redirect_back_or_default('/index')
	end

	def set_public
		if @schedule.update_attribute("public", !@schedule.public)
			@schedule.update_attribute("public", @schedule.public)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	private
	def has_manager_access
		unless is_current_manager_of(@schedule.group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

	def has_member_access
		unless is_current_member_of(@schedule.group) or @schedule.public
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

	def get_user
		@user = User.find(params[:id])
	end

	def get_schedule
		@schedule = Schedule.find(params[:id])
		@group = @schedule.group

		@the_previous = nil 
		@the_next = nil
		unless @group.is_branch?
			@the_previous = Schedule.previous(@schedule) 
			@the_next = Schedule.next(@schedule)  
		end  
		
	end

	def get_current_schedule
		@schedules = Schedule.current_schedules(current_user, params[:page])
		@has_no_schedules = (@schedules.nil? or @schedules.blank?)
	end

	def get_match_type 
		store_location 
		unless is_current_member_of(@schedule.group) or @schedule.public 
			redirect_to :action => 'index'
			return
		end
		@match_type = Match.get_match_type
	end

	def get_group
		# depended on number of groups for current user 
		# a group id is needed
		if current_user.groups.count == 0
			redirect_to :controller => 'groups', :action => 'new' 
			return

		elsif current_user.groups.count == 1 
			@group = current_user.groups.first()

		elsif current_user.groups.count > 1 and !params[:id].nil?
			@group = Group.find(params[:id])

		elsif current_user.groups.count > 1 and params[:id].nil? 
			redirect_to :controller => 'groups', :action => 'index' 
			return
		end

	end

	def excess_players
		# unless @schedule.convocados.empty? or @schedule.player_limit == 0
		#   flash[:warning] = I18n.t(:schedule_excess_player) if (@schedule.convocados.count > @schedule.player_limit)  
		# end
	end
end

