class MarkersController < ApplicationController
  def index
    @markers = Marker.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @markers = Marker.find(params[:id])
  end
  
  def new
    @markers = Marker.new
  end
  
  def create
    @markers = Marker.new(params[:markers])
    if @markers.save
      flash[:notice] = "Successfully created markers."
      redirect_to @markers
    else
      render :action => 'new'
    end
  end
  
  def edit
    @markers = Marker.find(params[:id])
  end
  
  def update
    @markers = Marker.find(params[:id])
    if @markers.update_attributes(params[:markers])
      flash[:notice] = "Successfully updated markers."
      redirect_to @markers
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @markers = Marker.find(params[:id])
    @markers.destroy
    flash[:notice] = "Successfully destroyed markers."
    redirect_to markers_url
  end
end
