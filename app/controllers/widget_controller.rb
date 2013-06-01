class WidgetController < ApplicationController
  layout nil
  
  def index
  end
  
  def home
    
    currentBranch = Branch.branch_from_url(request.env["HTTP_REFERER"]) 
    @centreSchedules = Timetable.schedules_from_timetables(currentBranch)
        
    render :layout => 'widget'
  end
  
end
