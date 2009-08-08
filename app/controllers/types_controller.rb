class TypesController < ApplicationController
  def index
    @types = Types.all
  end
  
  def show
    @types = Types.find(params[:id])
  end
  
  def new
    @types = Types.new
  end
  
  def create
    @types = Types.new(params[:types])
    if @types.save
      flash[:notice] = "Successfully created types."
      redirect_to @types
    else
      render :action => 'new'
    end
  end
  
  def edit
    @types = Types.find(params[:id])
  end
  
  def update
    @types = Types.find(params[:id])
    if @types.update_attributes(params[:types])
      flash[:notice] = "Successfully updated types."
      redirect_to @types
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @types = Types.find(params[:id])
    @types.destroy
    flash[:notice] = "Successfully destroyed types."
    redirect_to types_url
  end
end
