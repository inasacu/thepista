class TypesController < ApplicationController  
  before_filter :require_user
  before_filter :the_maximo

  def index
    @types = Type.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    redirect_to :action => 'index'
  end

  def new
    @types = Type.new
  end

  def create
    @types = Type.new(params[:types])
    if @types.save
      flash[:notice] = I18n.t(:succesfully_created)
      redirect_to @types
    else
      render :action => 'new'
    end
  end

  def edit
    @types = Type.find(params[:id])
  end

  def update
    @types = Type.find(params[:id])
    if @types.update_attributes(params[:types])
      flash[:notice] = I18n.t(:succesfully_updated)
      redirect_to @types
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
