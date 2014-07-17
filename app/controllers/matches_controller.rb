class MatchesController < ApplicationController
	before_filter :require_user,              :except => [:set_status_link]

	before_filter :get_match_and_user_x_two,  :only =>[:set_status, :set_team, :set_status_link]
	before_filter :has_member_access,         :only => [:set_match_profile]

	def index
		redirect_to :controller => 'schedules', :action => 'index'
	end

	def edit
		@match = Match.find(params[:id])
		@schedule = @match.schedule
  	# @matches = @schedule.the_roster
  	@matches = @schedule.the_roster_wo_default_user

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
			
			Schedule.delay.send_after_scorecards if USE_DELAYED_JOBS
			Schedule.send_after_scorecards unless USE_DELAYED_JOBS
			
			Match.set_default_user_to_ausente(@match)
			
			# controller_successful_update
			flash[:notice] = I18n.t(:update_match_scorecard)
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

		the_schedule = @match.schedule
		player_limit = the_schedule.player_limit
		total_players = the_schedule.the_roster_count		
		has_player_limit = (total_players >= player_limit)
		send_last_minute_message = (has_player_limit and NEXT_48_HOURS > the_schedule.starts_at and the_schedule.send_reminder_at.nil?)
		
		if send_last_minute_message
			
			type_change = [[1,2,-1], [1,3,-1]] 
			type_change = [[1,2,-1], [1,3,-1], [2,1,1], [3,1,1]] if DISPLAY_FREMIUM_SERVICES
			send_last_minute_message = false
			
			type_change.each do |a, b, change|
				new_player_limit = total_players + change
				send_last_minute_message = (@match.type_id == a and @type.id == b and player_limit < new_player_limit) ? true : send_last_minute_message
			end
			
			if send_last_minute_message	
				the_schedule.last_minute_reminder 
				the_schedule.send_reminder_at = Time.zone.now
				the_schedule.save
			end
		end

		if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.zone.now)
		  
			Scorecard.delay.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group) if USE_DELAYED_JOBS
  		Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group).deliver unless USE_DELAYED_JOBS

			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
			
		end 

    
		redirect_back_or_default('/index')
		# redirect_to :root_url
		return
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
			
			Schedule.delay.create_notification_email(@match.schedule, @match.schedule, manager_id, @match.user_id, true) if USE_DELAYED_JOBS
			Schedule.create_notification_email(@match.schedule, @match.schedule, manager_id, @match.user_id, true).deliver unless USE_DELAYED_JOBS     
			Scorecard.delay.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group) if USE_DELAYED_JOBS   
			Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group).deliver unless USE_DELAYED_JOBS

			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
		end 
		redirect_to root_url
	end

	def set_yo_convocado
	  user = User.find(:first, :conditions => ["yo_username = ?", params[:username]])
	  unless user
	    redirect_to root_url
	    return
    end
    
    matches = Match.find(:all, :select => "matches.*",
                          :joins => "left join schedules on schedules.id = matches.schedule_id",
                          :conditions => ["matches.user_id = ? and schedules.starts_at > ? and schedules.ends_at < ? and 
                                           schedules.played = false and schedules.archive = false and matches.archive = false", user, Time.zone.now, NEXT_SEVEN_DAYS])   
	  unless matches
	    redirect_to root_url
	    return
    end
                          
    type = Type.find(1)
    matches.each do |match|
      played = (type.id == 1 and !match.group_score.nil? and !match.invite_score.nil?)
      
      # 1 == player is in team one
  		# x == game tied, doesnt matter where player is
  		# 2 == player is in team two      
  		user_x_two = "1" if (match.group_id.to_i > 0 and match.invite_id.to_i == 0)
  		user_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
  		user_x_two = "2" if (match.group_id.to_i == 0 and match.invite_id.to_i > 0)
  		
      unless match.type_id != type
        if match.update_attributes(:type_id => type.id, :played => played, :user_x_two => user_x_two, :status_at => Time.zone.now)
          manager_id = RolesUsers.find_item_manager(match.schedule.group).user_id
          Schedule.create_notification_email(match.schedule, match.schedule, manager_id, match.user_id, true) 
          Scorecard.calculate_user_played_assigned_scorecard(match.user, match.schedule.group) 
        end 
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
		
		@user = User.find(current_user)

		played = (@match.type_id.to_i == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

		if @match.update_attributes(:group_id => @match.invite_id, :invite_id => @match.group_id, :played => played, :user_x_two => @user_x_two, :change_id => @user.id, :changed_at => Time.zone.now)
			Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
			controller_successful_update			
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
