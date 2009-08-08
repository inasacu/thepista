class SportsController < ApplicationController
  def index
    @sports = Sports.all
  end
  
  def show
    @sports = Sports.find(params[:id])
  end
  
  def new
    @sports = Sports.new
  end
  
  def create
    @sports = Sports.new(params[:sports])
    if @sports.save
      flash[:notice] = "Successfully created sports."
      redirect_to @sports
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sports = Sports.find(params[:id])
  end
  
  def update
    @sports = Sports.find(params[:id])
    if @sports.update_attributes(params[:sports])
      flash[:notice] = "Successfully updated sports."
      redirect_to @sports
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sports = Sports.find(params[:id])
    @sports.destroy
    flash[:notice] = "Successfully destroyed sports."
    redirect_to sports_url
  end
end
