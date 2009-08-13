class MatchesController < ApplicationController
  before_filter :require_user

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
      flash[:notice] =  I18n.t(:successful_create)
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
      flash[:notice] =  I18n.t(:successful_update)
      redirect_to @matches
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @matches = Match.find(params[:id])
    @matches.destroy
    flash[:notice] =  I18n.t(:successful_destroy)
    redirect_to matches_url
  end
end
