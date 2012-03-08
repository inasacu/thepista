class RolesController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo

  def index
    @roles = Role.page(params[:page])
    render @the_template  
  end

  def show
    @roles = Role.find(params[:id])
    render @the_template  
  end

  def new
    @roles = Role.new
    render @the_template  
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
    set_the_template('roles/new')
    render @the_template
  end

  def update
    @roles = Role.find(params[:id])
    if @roles.update_attributes(params[:roles])
      flash[:success] = I18n.t(:successful_update)
      redirect_to @roles
    else
      render :action => 'edit'
    end
  end

  private 
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end

end