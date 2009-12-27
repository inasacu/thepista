class CloudsController < ApplicationController
  before_filter :require_user
  
  def show
    @schedules = Schedule.tagged_with(params[:id]).paginate(:page => params[:page], :per_page => SCHEDULES_PER_PAGE)
    @clouds = Schedule.tagged_with(params[:id]).paginate(:page => params[:page], :per_page => SCHEDULES_PER_PAGE)
    
    render :template => '/schedules/index' 
  end
  
end
