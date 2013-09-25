class WidgetController < ApplicationController
  layout nil
  
  # filters
  before_filter :check_branch
  before_filter :get_schedule, :only => [:event_details, :event_details_noshow, :event_details_lastminute]
  before_filter :check_redirect, :only => [:home]
  before_filter :check_disqus_logout, :only => [:event_details]
  before_filter :get_match_and_user_x_two, :only => [:set_team]
  
  helper WidgetHelper
  
  def index
    respond_to do |format|
      format.js
    end
  end
  
  def home
       
    # Gets the schedules from the branch if new or changed site
    if !session[:current_branch].nil?
      
      @schedules_per_weekday = Schedule.week_schedules_from_timetables(session[:current_branch])
      
      if @current_user
        @my_schedules = Schedule.widget_my_current_schedules(current_user, session[:current_branch])
      end
      
    else
      session.delete(:current_branch)
      #session.delete(:current_branch_real_url)
      session.delete(:original_referrer)
      render nothing: true
      return
    end
    
    render :layout => 'widget'
    
  end
  
  def check_omniauth
    
    @user = User.new
		if session[:omniauth]
		  
		  # info for logic actions
			@isevent = params[:isevent]
      @ismock = params[:ismock]
      @event =  params[:event]
      @source_timetable_id =  params[:source_timetable_id]
      @block_token = params[:block_token]
      
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
      end
      
    end
    
  end
  
  def signup
    render :layout => 'widget'
  end
  
  def do_apuntate
    
    if params[:block_token]
      block_token = Base64::decode64(params[:block_token].to_s).to_i
      event_starts_at = Time.zone.at(block_token)
    end
          
    event = Schedule.takecareof_apuntate(current_user, params[:isevent], params[:ismock], 
                                        params[:event], params[:source_timetable_id], event_starts_at)
    
    if !event.nil?
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
		@status_count_hash = @schedule.get_status_count
    
    render "/widget/event", :layout => 'widget'
  end
  
  def event_details_noshow
    store_location
		@has_a_roster = !(@schedule.no_shows.empty?)
		@the_roster = @schedule.the_no_show
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		@status_count_hash = @schedule.get_status_count
		
		set_the_template('schedules/team_roster')
		render "/widget/event", :layout => 'widget'
  end
  
  def event_details_lastminute
		store_location
		@has_a_roster = !(@schedule.the_last_minute.empty?)
		@the_roster = @schedule.the_last_minute
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		@status_count_hash = @schedule.get_status_count
		
		set_the_template('schedules/team_roster')
		render "/widget/event", :layout => 'widget'
	end
  
  def event_invitation
    
    @invitation = Invitation.new

    if (params[:event_id])
      @schedule = Schedule.find(params[:event_id])
      @status_count_hash = @schedule.get_status_count
    end

    render "/widget/new_invitation", :layout => 'widget'
    
  end
  
  def change_user_state
    
    begin
      
      the_schedule = Schedule.change_user_state(current_user, params[:matchid], params[:newstate])
      
      if !the_schedule.nil?
        flash[:notice] = "Se ha cambiado el estado del jugador en el evento"
        status_count_hash = the_schedule.get_status_count
        
        redirect_url = widget_event_details_lastminute_url :event_id => the_schedule.id if status_count_hash[:last_minute_count] > 0
        redirect_url = widget_event_details_noshow_url :event_id => the_schedule.id if status_count_hash[:no_show_count] > 0
        redirect_url = widget_event_details_url :event_id => the_schedule.id if status_count_hash[:roster_count] > 0
                
    		redirect_to redirect_url
      else
        flash[:notice] = "Ha ocurrido un error al cambiar el estado"
    		redirect_to widget_home_url
      end
      
    rescue => ex
      
      logger.error "Excepcion #{ex.message}"
      
      flash[:notice] = "Ha ocurrido un error al cambiar el estado"
  		redirect_to widget_home_url
  		
    end
    
		return
		
	end
	
	def set_team 
		unless is_current_member_of(@match.schedule.group)
			warning_unauthorized
			redirect_to widget_home_url
			return
		end
		
		@user = User.find(current_user)

		played = (@match.type_id.to_i == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

		if @match.update_attributes(:group_id => @match.invite_id, :invite_id => @match.group_id, 
		          :played => played, :user_x_two => @user_x_two, :change_id => @user.id, 
		          :changed_at => Time.zone.now)
		          
			Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
			
		end
		
		redirect_to widget_event_details_url :event_id => @match.schedule.id
    return
	end
  
  # getters and others ------------------->
  
  def check_branch
        
    # If tried to access directly from browser
    if request.env["HTTP_REFERER"].nil? 
      
      if params[:from_omni_auth] == "1"
        render :partial => "/widget/partials/close_reload_iframe"
      else
        render nothing: true
      end
      return
    end
    
    # Clean versions of the urls
    @clean_root_url = WidgetHelper.clean_branch_url(root_url)
    @clean_referrer = WidgetHelper.clean_branch_url(request.env["HTTP_REFERER"])
    if !session[:current_branch].nil?
      clean_current_branch_url = WidgetHelper.clean_branch_url(session[:current_branch].url)
    end
    
    # Gets the current branch if not present in session 
    # or the website changed
    # and request doesnt come from root_url
    if ( session[:current_branch].nil? and !(@clean_referrer.start_with?(@clean_root_url)) ) \
       or (!session[:current_branch].nil? \
            and (@clean_referrer != clean_current_branch_url) \
            and !(@clean_referrer.start_with?(@clean_root_url)) ) \
       or !params[:branch].nil?
                
        if !params[:branch].nil?
          session[:current_branch] = Branch.branch_from_url(params[:branch]) 
          #session[:current_branch_real_url] = session[:current_branch].url
        else
          session[:current_branch] = Branch.branch_from_url(@clean_referrer) 
          #session[:current_branch_real_url] = request.env["HTTP_REFERER"]
        end
        
    end
    
    # If the param is sent it means that home button pressed
    # and the param should continue being used as help to get branch
    if params[:branch]
      @clean_referrer = params[:branch]
    end
    
    # If comming back to home from a schedule gets the branch
    # from schedule group
    if params[:prev_schedule]
      schedule = Schedule.find(params[:prev_schedule])
      session[:current_branch] = Branch.find(schedule.group.item.id)
      #session[:current_branch_real_url] = session[:current_branch].url

      @clean_referrer = WidgetHelper.clean_branch_url(session[:current_branch].url)
    end
    
  end
  
  def check_redirect
      
      if !request.env["HTTP_REFERER"].nil?
        referer_url = URI.escape(request.env["HTTP_REFERER"])

        if !URI(referer_url).query.nil?
          params_hash = CGI.parse(URI(request.env["HTTP_REFERER"]).query)
          
          if !params_hash["invitation_to_event"].nil? and !params_hash["event_id"].nil?
            if !params_hash["event_id"][0].nil?
              redirect_to widget_event_details_url :event_id => params_hash["event_id"][0]
              return
            end
          end
        end
      end
    
  end
  
  def check_disqus_logout
    
    @should_close_due_disqus = false
    if !request.env["HTTP_REFERER"].nil? and request.env["HTTP_REFERER"].include? "disqus.com"
       @should_close_due_disqus = true
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
