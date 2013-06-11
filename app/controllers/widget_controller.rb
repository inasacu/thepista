class WidgetController < ApplicationController
  layout nil
  
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
  
end
