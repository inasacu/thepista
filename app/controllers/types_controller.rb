class TypesController < ApplicationController
  
  before_filter :require_user

  def index
    @types = Type.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @types = Type.find(params[:id])
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
  
  def destroy
    @types = Type.find(params[:id])
    @types.destroy
    flash[:notice] = I18n.t(:succesfully_destroyed)
    redirect_to types_url
  end
end
