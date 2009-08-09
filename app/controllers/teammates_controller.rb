class TeammatesController < ApplicationController
  def index
    @teammates = Teammate.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @teammates = Teammate.find(params[:id])
  end
  
  def new
    @teammates = Teammate.new
  end
  
  def create
    @teammates = Teammate.new(params[:teammates])
    if @teammates.save
      flash[:notice] = "Successfully created teammates."
      redirect_to @teammates
    else
      render :action => 'new'
    end
  end
  
  def edit
    @teammates = Teammate.find(params[:id])
  end
  
  def update
    @teammates = Teammate.find(params[:id])
    if @teammates.update_attributes(params[:teammates])
      flash[:notice] = "Successfully updated teammates."
      redirect_to @teammates
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @teammates = Teammate.find(params[:id])
    @teammates.destroy
    flash[:notice] = "Successfully destroyed teammates."
    redirect_to teammates_url
  end
end

