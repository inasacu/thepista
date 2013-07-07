class WidgetController < ApplicationController
  layout nil
  
  # filters
  before_filter :get_schedule, :only => [:event_details]
  before_filter :check_redirect, :only => [:home]
    
  # add filter for checkin branch in session
  
  helper WidgetHelper
  
  def index
  end
  
  def home
    
    if !session[:current_branch]
      session[:current_branch] = Branch.branch_from_url(request.env["HTTP_REFERER"]) 
    end 
    
    if params[:inside_redirect]
      @event_to_redirect = params[:event_id]
    end
    
    @schedules_per_weekday = Schedule.week_schedules_from_timetables(session[:current_branch])
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
  
  def ajaxtest
    logger.info "AJAX TEST"
    respond_to do |format|  
        format.js  
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
      session["widgetpista.event_starts_at"] =  Time.zone.at(Base64::decode64(params[:block_token].to_s).to_i)
    end
    
  end
  
  def signup
    render :layout => 'widget'
  end
  
  def do_apuntate
    
    if params[:block_token]
      event_starts_at = Base64::decode64(params[:block_token].to_s).to_time
    end
          
    event = Schedule.takecareof_apuntate(current_user, params[:isevent], params[:ismock], params[:event], params[:source_timetable_id], event_starts_at)
    
    if event
      redirect_to widget_event_details_url :event_id => event.id
    else
      redirect_to widget_home_url
    end
    
  end
  
  def change_user_state
    
    userid = params[:userid]
    newstate = params[:newstate]
    
    # logic to change state of the user regarding the event
    
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
  
  # getters and others ------------------->
  
  def check_redirect
    
      if !request.env["HTTP_REFERER"].nil?
        referer_url = URI.escape(request.env["HTTP_REFERER"])

        if !URI(referer_url).query.nil?
          params_hash = CGI.parse(URI(request.env["HTTP_REFERER"]).query)

          if params_hash[:invitation_to_event] and params_hash[:event_id]
            redirect_to widget_event_details_url :event_id => params_hash['event_id'][0]
            return
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
  
end
