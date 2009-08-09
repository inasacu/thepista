class GroupsController < ApplicationController
  def index
    @groups = Group.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @groups = Group.find(params[:id])
  end
  
  def new
    @groups = Group.new
  end
  
  def create
    @groups = Group.new(params[:groups])
    if @groups.save
      flash[:notice] = "Successfully created groups."
      redirect_to @groups
    else
      render :action => 'new'
    end
  end
  
  def edit
    @groups = Group.find(params[:id])
  end
  
  def update
    @groups = Group.find(params[:id])
    if @groups.update_attributes(params[:groups])
      flash[:notice] = "Successfully updated groups."
      redirect_to @groups
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @groups = Group.find(params[:id])
    @groups.destroy
    flash[:notice] = "Successfully destroyed groups."
    redirect_to groups_url
  end
end
