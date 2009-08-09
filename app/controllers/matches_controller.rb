class MatchesController < ApplicationController
  def index
    @matches = Match.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @matches = Match.find(params[:id])
  end
  
  def new
    @matches = Match.new
  end
  
  def create
    @matches = Match.new(params[:matches])
    if @matches.save
      flash[:notice] = "Successfully created matches."
      redirect_to @matches
    else
      render :action => 'new'
    end
  end
  
  def edit
    @matches = Match.find(params[:id])
  end
  
  def update
    @matches = Match.find(params[:id])
    if @matches.update_attributes(params[:matches])
      flash[:notice] = "Successfully updated matches."
      redirect_to @matches
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @matches = Match.find(params[:id])
    @matches.destroy
    flash[:notice] = "Successfully destroyed matches."
    redirect_to matches_url
  end
end
