class WidgetController < ApplicationController
  layout nil
  
  def index
  end
  
  def home
    
    currentBranch = Branch.branch_from_url(request.env["HTTP_REFERER"]) 
    
    if !currentBranch.nil?
      @schedulesPerWeekDay = Timetable.week_schedules_from_timetables(currentBranch)
    end
        
    render :layout => 'widget'
  end
  
end
