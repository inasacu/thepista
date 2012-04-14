class SportsController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo

  def index    
    @sports = Sport.page(params[:page])
    render @the_template
  end

  def show
    @sport = Sport.find(params[:id])
    render @the_template
  end

  def new
    @sport = Sport.new
    render @the_template
  end

  def create
    @sport = Sport.new(params[:sport])
    if @sport.save
      successful_create
      redirect_to @sport
    else
      render :action => 'new'
    end
  end

  def edit
    @sport = Sport.find(params[:id])
    set_the_template('sports/new')
    render @the_template
  end

  def update
    @sport = Sport.find(params[:id])
    if @sport.update_attributes(params[:sport])
      flash[:success] = I18n.t(:successful_update)
      redirect_to sports_url
      return
    else
      render :action => 'edit'
    end
  end

  private 
  def the_maximo
    unless the_maximo 
      redirect_to root_url
      return
    end
  end

end
