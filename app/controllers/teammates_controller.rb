class TeammatesController < ApplicationController
  def index
    @teammates = Teammates.all
  end
  
  def show
    @teammates = Teammates.find(params[:id])
  end
  
  def new
    @teammates = Teammates.new
  end
  
  def create
    @teammates = Teammates.new(params[:teammates])
    if @teammates.save
      flash[:notice] = "Successfully created teammates."
      redirect_to @teammates
    else
      render :action => 'new'
    end
  end
  
  def edit
    @teammates = Teammates.find(params[:id])
  end
  
  def update
    @teammates = Teammates.find(params[:id])
    if @teammates.update_attributes(params[:teammates])
      flash[:notice] = "Successfully updated teammates."
      redirect_to @teammates
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @teammates = Teammates.find(params[:id])
    @teammates.destroy
    flash[:notice] = "Successfully destroyed teammates."
    redirect_to teammates_url
  end
end
