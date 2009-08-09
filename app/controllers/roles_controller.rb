class RolesController < ApplicationController
  def index
    @roles = Role.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @roles = Role.find(params[:id])
  end
  
  def new
    @roles = Role.new
  end
  
  def create
    @roles = Role.new(params[:roles])
    if @roles.save
      flash[:notice] = "Successfully created roles."
      redirect_to @roles
    else
      render :action => 'new'
    end
  end
  
  def edit
    @roles = Role.find(params[:id])
  end
  
  def update
    @roles = Role.find(params[:id])
    if @roles.update_attributes(params[:roles])
      flash[:notice] = "Successfully updated roles."
      redirect_to @roles
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @roles = Role.find(params[:id])
    @roles.destroy
    flash[:notice] = "Successfully destroyed roles."
    redirect_to roles_url
  end
end
