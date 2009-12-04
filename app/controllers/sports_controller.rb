class SportsController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo

  def index    
    @sports = Sport.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @sport = Sport.find(params[:id])
  end
  
  def new
    @sport = Sport.new
  end
  
  def create
    @sport = Sport.new(params[:sport])
    if @sport.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @sport
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sport = Sport.find(params[:id])
  end
  
  def update
    @sport = Sport.find(params[:id])
    if @sport.update_attributes(params[:sport])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @sport
    else
      render :action => 'edit'
    end
  end
  
  private 
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end
  
end
