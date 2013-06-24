class WidgetController < ApplicationController
  layout nil
  
  # add filter for checkin branch in session
  
  helper WidgetHelper
  
  def index
  end
  
  def home
    
    if !session[:current_branch]
      session[:current_branch] = Branch.branch_from_url(request.env["HTTP_REFERER"]) 
    end 
    
    @schedulesPerWeekDay = Schedule.week_schedules_from_timetables(session[:current_branch])
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
    
    request.env["widgetpista.isevent"] = params[:isevent]
    
    if request.env["widgetpista.isevent"]
      # if the login check was requested by the apuntate link
      request.env["widgetpista.ismock"] = params[:ismock]
      request.env["widgetpista.eventid"] =  params[:event]
    else
      # login was requested by the regular login link
      request.env["widgetpista.ismock"] = nil
      request.env["widgetpista.eventid"] =  nil
    end
    
  end
  
  def signup
    render :layout => 'widget'
  end
  
end
