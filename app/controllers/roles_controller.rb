class RolesController < ApplicationController
  before_filter :require_user
  
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
      flash[:notice] = I18n.t(:successful_create)
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
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @roles
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @roles = Role.find(params[:id])
    @roles.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to roles_url
  end
end
