class SportsController < ApplicationController
  def index
    @sports = Sport.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @sports = Sport.find(params[:id])
  end
  
  def new
    @sports = Sport.new
  end
  
  def create
    @sports = Sport.new(params[:sports])
    if @sports.save
      flash[:notice] = "Successfully created sports."
      redirect_to @sports
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sports = Sport.find(params[:id])
  end
  
  def update
    @sports = Sport.find(params[:id])
    if @sports.update_attributes(params[:sports])
      flash[:notice] = "Successfully updated sports."
      redirect_to @sports
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sports = Sport.find(params[:id])
    @sports.destroy
    flash[:notice] = "Successfully destroyed sports."
    redirect_to sports_url
  end
end
