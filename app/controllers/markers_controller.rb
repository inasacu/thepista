class MarkersController < ApplicationController
  def index
    @markers = Markers.all
  end
  
  def show
    @markers = Markers.find(params[:id])
  end
  
  def new
    @markers = Markers.new
  end
  
  def create
    @markers = Markers.new(params[:markers])
    if @markers.save
      flash[:notice] = "Successfully created markers."
      redirect_to @markers
    else
      render :action => 'new'
    end
  end
  
  def edit
    @markers = Markers.find(params[:id])
  end
  
  def update
    @markers = Markers.find(params[:id])
    if @markers.update_attributes(params[:markers])
      flash[:notice] = "Successfully updated markers."
      redirect_to @markers
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @markers = Markers.find(params[:id])
    @markers.destroy
    flash[:notice] = "Successfully destroyed markers."
    redirect_to markers_url
  end
end
