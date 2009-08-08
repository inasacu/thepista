class RolesController < ApplicationController
  def index
    @roles = Roles.all
  end
  
  def show
    @roles = Roles.find(params[:id])
  end
  
  def new
    @roles = Roles.new
  end
  
  def create
    @roles = Roles.new(params[:roles])
    if @roles.save
      flash[:notice] = "Successfully created roles."
      redirect_to @roles
    else
      render :action => 'new'
    end
  end
  
  def edit
    @roles = Roles.find(params[:id])
  end
  
  def update
    @roles = Roles.find(params[:id])
    if @roles.update_attributes(params[:roles])
      flash[:notice] = "Successfully updated roles."
      redirect_to @roles
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @roles = Roles.find(params[:id])
    @roles.destroy
    flash[:notice] = "Successfully destroyed roles."
    redirect_to roles_url
  end
end
