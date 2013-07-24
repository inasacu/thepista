class WidgetController < ApplicationController
  layout nil
  
  # filters
  before_filter :get_schedule, :only => [:event_details]
  before_filter :check_redirect, :only => [:home]
  before_filter :get_match_and_user_x_two, :only => [:change_user_state]
    
  # add filter for checkin branch in session
  
  helper WidgetHelper
  
  def index
  end
  
  def home
    
    # Gets the current branch if not present in session
    if session[:current_branch].nil?
      if !request.env["HTTP_REFERER"].nil?
        session[:current_branch] = Branch.branch_from_url(request.env["HTTP_REFERER"]) 
        session[:current_branch_real_url] = request.env["HTTP_REFERER"]
      else
        session.delete(:current_branch)
        render nothing: true
        return
      end
    end 
   
    logger.info "paso #{session[:current_branch].url}"
    
    # Gets the schedules from the branch
    if !session[:current_branch].nil?
      
      @schedules_per_weekday = Schedule.week_schedules_from_timetables(session[:current_branch])
      
      if @current_user
        @my_schedules = Schedule.widget_my_current_schedules(current_user, session[:current_branch])
      end
      
    else
      session.delete(:current_branch)
      session.delete(:current_branch_real_url)
      render nothing: true
      return
    end
    
    render :layout => 'widget'
    
  end
  
  def check_omniauth
    
    @user = User.new
		if session[:omniauth]
		  
			@user.apply_omniauth(session[:omniauth])
			@user.valid?
			render '/widget/signup', :layout => 'widget'
		
		else  
		  redirect_to widget_home_url
		end
    
  end
  
  def login_check
    
    WidgetHelper.clean_session(session)
    
    if params[:isevent] == "true"
      # if the login check was requested by the apuntate link
      session["widgetpista.isevent"] = params[:isevent]
      session["widgetpista.ismock"] = params[:ismock]
      session["widgetpista.eventid"] =  params[:event]
      session["widgetpista.source_timetable_id"] =  params[:source_timetable_id]
      
      if params[:block_token]
        block_token = Base64::decode64(params[:block_token].to_s).to_i
        session["widgetpista.event_starts_at"] =  Time.zone.at(block_token)
      else
      end
      
    end
    
  end
  
  def signup
    render :layout => 'widget'
  end
  
  def do_apuntate
    
    if params[:block_token]
      event_starts_at = Base64::decode64(params[:block_token].to_s).to_time
    end
          
    event = Schedule.takecareof_apuntate(current_user, params[:isevent], params[:ismock], 
                                        params[:event], params[:source_timetable_id], event_starts_at)
    
    if event
      redirect_to widget_event_details_url :event_id => event.id
    else
      redirect_to widget_home_url
    end
    
  end
  
  def event_details
    store_location
    
		@has_a_roster = !(@schedule.convocados.empty?)
		@the_roster = @schedule.the_roster_sort(sort_order(''))
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
    
    render "/widget/event", :layout => 'widget'
  end
  
  def event_invitation
    
    @invitation = Invitation.new

    if (params[:event_id])
      @schedule = Schedule.find(params[:event_id])
    end

    render "/widget/new_invitation", :layout => 'widget'
    
  end
  
  def change_user_state
    
    the_schedule = @match.schedule
    
		unless current_user == @match.user or is_current_manager_of(the_schedule.group) 
			warning_unauthorized
			redirect_to widget_home_url
			return
		end

		@type = Type.find(params[:newstate])
		played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

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
			# delay instruction was removed because was throwing stack too deep error
			Scorecard.calculate_user_played_assigned_scorecard(@match.user, the_schedule.group)
          
			if DISPLAY_FREMIUM_SERVICES
				# set fee type_id to same as match type_id
				the_fee = Fee.find(:all, :conditions => ["debit_type = 'User' and debit_id = ? and item_type = 'Schedule' and item_id = ?", @match.user_id, @match.schedule_id])
				the_fee.each {|fee| fee.type_id = @type.id; fee.save}
			end
			
		end 
    
    flash[:notice] = "Se ha cambiado tu estado en el evento"
    
		redirect_to widget_event_details_url :event_id => the_schedule.id
		return
	end
  
  # getters and others ------------------->
  
  def check_redirect
    
      if !request.env["HTTP_REFERER"].nil?
        referer_url = URI.escape(request.env["HTTP_REFERER"])

        if !URI(referer_url).query.nil?
          params_hash = CGI.parse(URI(request.env["HTTP_REFERER"]).query)

          if !params_hash[:invitation_to_event].nil? and !params_hash[:event_id].nil?
            if !params_hash[:event_id][0].nil?
              redirect_to widget_event_details_url :event_id => params_hash['event_id'][0]
              return
            end
          end
        end
      end
    
  end
  
  def get_schedule
		@schedule = Schedule.find(params[:event_id])
		@group = @schedule.group
		@the_previous = Schedule.previous(@schedule)
		@the_next = Schedule.next(@schedule)    
	end
	
	def get_match_and_user_x_two
		@match = Match.find(params[:matchid])

		# 1 == player is in team one
		# x == game tied, doesnt matter where player is
		# 2 == player is in team two      
		@user_x_two = "1" if (@match.group_id.to_i > 0 and @match.invite_id.to_i == 0)
		@user_x_two = "X" if (@match.group_score.to_i == @match.invite_score.to_i)
		@user_x_two = "2" if (@match.group_id.to_i == 0 and @match.invite_id.to_i > 0)
	end
  
end
