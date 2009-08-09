class ScorecardsController < ApplicationController
  def index
    @scorecards = Scorecard.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @scorecards = Scorecard.find(params[:id])
  end
  
  def new
    @scorecards = Scorecard.new
  end
  
  def create
    @scorecards = Scorecard.new(params[:scorecards])
    if @scorecards.save
      flash[:notice] = "Successfully created scorecards."
      redirect_to @scorecards
    else
      render :action => 'new'
    end
  end
  
  def edit
    @scorecards = Scorecard.find(params[:id])
  end
  
  def update
    @scorecards = Scorecard.find(params[:id])
    if @scorecards.update_attributes(params[:scorecards])
      flash[:notice] = "Successfully updated scorecards."
      redirect_to @scorecards
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @scorecards = Scorecard.find(params[:id])
    @scorecards.destroy
    flash[:notice] = "Successfully destroyed scorecards."
    redirect_to scorecards_url
  end
end

