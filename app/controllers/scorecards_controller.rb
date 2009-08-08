class ScorecardsController < ApplicationController
  def index
    @scorecards = Scorecards.all
  end
  
  def show
    @scorecards = Scorecards.find(params[:id])
  end
  
  def new
    @scorecards = Scorecards.new
  end
  
  def create
    @scorecards = Scorecards.new(params[:scorecards])
    if @scorecards.save
      flash[:notice] = "Successfully created scorecards."
      redirect_to @scorecards
    else
      render :action => 'new'
    end
  end
  
  def edit
    @scorecards = Scorecards.find(params[:id])
  end
  
  def update
    @scorecards = Scorecards.find(params[:id])
    if @scorecards.update_attributes(params[:scorecards])
      flash[:notice] = "Successfully updated scorecards."
      redirect_to @scorecards
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @scorecards = Scorecards.find(params[:id])
    @scorecards.destroy
    flash[:notice] = "Successfully destroyed scorecards."
    redirect_to scorecards_url
  end
end
