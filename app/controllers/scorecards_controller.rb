class ScorecardsController < ApplicationController
  before_filter :require_user
  
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
      flash[:notice] = I18n.t(:successful_create)
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
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @scorecards
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @scorecards = Scorecard.find(params[:id])
    @scorecards.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to scorecards_url
  end
end

