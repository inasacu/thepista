class SchedulesController < ApplicationController
  def index
    @schedules = Schedules.all
  end
  
  def show
    @schedules = Schedules.find(params[:id])
  end
  
  def new
    @schedules = Schedules.new
  end
  
  def create
    @schedules = Schedules.new(params[:schedules])
    if @schedules.save
      flash[:notice] = "Successfully created schedules."
      redirect_to @schedules
    else
      render :action => 'new'
    end
  end
  
  def edit
    @schedules = Schedules.find(params[:id])
  end
  
  def update
    @schedules = Schedules.find(params[:id])
    if @schedules.update_attributes(params[:schedules])
      flash[:notice] = "Successfully updated schedules."
      redirect_to @schedules
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @schedules = Schedules.find(params[:id])
    @schedules.destroy
    flash[:notice] = "Successfully destroyed schedules."
    redirect_to schedules_url
  end
end
