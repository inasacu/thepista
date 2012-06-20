class MatchesController < ApplicationController
	before_filter :require_user,              :except => [:set_status_link]

	before_filter :get_match_and_user_x_two,  :only =>[:set_status, :set_team, :set_status_link]
	before_filter :has_member_access,         :only => [:set_match_profile]
	# before_filter :has_match_access,          :only => [:rate]

	def index
		redirect_to :controller => 'schedules', :action => 'index'
	end

	def edit
		@match = Match.find(params[:id])
		@schedule = @match.schedule
		@matches = @schedule.the_roster

		unless is_current_manager_of(@schedule.group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end    

		set_the_template('matches/new')
		render @the_template 
	end

	def update
		@match = Match.find(params[:id])
		the_group = @match.schedule.group

		unless is_current_manager_of(the_group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
		
		match_values = params[:match] 
		
		@match.group_score = match_values['group_score']
		@match.invite_score = match_values['invite_score']
		
		if @match.save and params[:match][:match_attributes]
			Match.save_matches(@match, params[:match][:match_attributes])
			Match.update_match_details(@match, current_user)

			controller_successful_update
			redirect_to :controller => 'schedules', :action => 'show', :id => @match.schedule
		else
			render :action => 'edit'
		end
	end 

	def set_status
		unless current_user == @match.user or is_current_manager_of(@match.schedule.group) 
			warning_unauthorized
			redirect_to root_url
			return
		end

		@type = Type.find(params[:type])
		played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)


		if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.zone.now)
			Scorecard.delay.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)

			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
		end 

		redirect_back_or_default('/index')
	end 

	def set_status_link
		unless (@match.block_token == params[:block_token])
			warning_unauthorized
			redirect_to root_url
			return
		end

		@type = Type.find(params[:type])
		played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

		if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.zone.now)

			manager_id = RolesUsers.find_item_manager(@match.schedule.group).user_id
			Schedule.delay.create_notification_email(@match.schedule, @match.schedule, manager_id, @match.user_id, true)      
			Scorecard.delay.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)

			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
		end 
		redirect_to root_url
	end

	def set_team 
		unless is_current_member_of(@match.schedule.group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end

		played = (@match.type_id.to_i == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

		if @match.update_attributes(:group_id => @match.invite_id, :invite_id => @match.group_id, 
			:played => played, :user_x_two => @user_x_two)

			Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
		end
		redirect_back_or_default('/index')
	end

	private
	def has_manager_access
		unless is_current_manager_of(@schedule.group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

	def get_match_and_user_x_two
		@match = Match.find(params[:id])

		# 1 == player is in team one
		# x == game tied, doesnt matter where player is
		# 2 == player is in team two      
		@user_x_two = "1" if (@match.group_id.to_i > 0 and @match.invite_id.to_i == 0)
		@user_x_two = "X" if (@match.group_score.to_i == @match.invite_score.to_i)
		@user_x_two = "2" if (@match.group_id.to_i == 0 and @match.invite_id.to_i > 0)
	end

	def has_member_access
		@schedule = Schedule.find(params[:id])
		unless is_current_member_of(@schedule.group) 
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end


	def has_match_access
		@match = Match.find(params[:id])
		@schedule = @match.schedule
		unless is_current_member_of(@schedule.group) 
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

end
