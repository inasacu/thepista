class MatchesController < ApplicationController
  def index
    @matches = Matches.all
  end
  
  def show
    @matches = Matches.find(params[:id])
  end
  
  def new
    @matches = Matches.new
  end
  
  def create
    @matches = Matches.new(params[:matches])
    if @matches.save
      flash[:notice] = "Successfully created matches."
      redirect_to @matches
    else
      render :action => 'new'
    end
  end
  
  def edit
    @matches = Matches.find(params[:id])
  end
  
  def update
    @matches = Matches.find(params[:id])
    if @matches.update_attributes(params[:matches])
      flash[:notice] = "Successfully updated matches."
      redirect_to @matches
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @matches = Matches.find(params[:id])
    @matches.destroy
    flash[:notice] = "Successfully destroyed matches."
    redirect_to matches_url
  end
end
