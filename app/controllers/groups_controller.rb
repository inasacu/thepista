class GroupsController < ApplicationController
  def index
    @groups = Groups.all
  end
  
  def show
    @groups = Groups.find(params[:id])
  end
  
  def new
    @groups = Groups.new
  end
  
  def create
    @groups = Groups.new(params[:groups])
    if @groups.save
      flash[:notice] = "Successfully created groups."
      redirect_to @groups
    else
      render :action => 'new'
    end
  end
  
  def edit
    @groups = Groups.find(params[:id])
  end
  
  def update
    @groups = Groups.find(params[:id])
    if @groups.update_attributes(params[:groups])
      flash[:notice] = "Successfully updated groups."
      redirect_to @groups
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @groups = Groups.find(params[:id])
    @groups.destroy
    flash[:notice] = "Successfully destroyed groups."
    redirect_to groups_url
  end
end
