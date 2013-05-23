class WidgetController < ApplicationController
  layout nil
  
  def index
  end
  
  def home
    @centreSchedules = Schedule.find(:all)
    
    render :layout => 'widget'
  end
  
end
