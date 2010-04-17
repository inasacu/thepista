class SquadsController < ApplicationController
  before_filter :require_user
  # before_filter :the_maximo

  def index    
    @cup = Cup.find(params[:id])
    @squads = @cup.squads
  end

  def show
    @squad = Squad.find(params[:id])
    @cup = @squad.cups.first
  end

  def new
    @squad = Squad.new
    @cup = Cup.find(params[:id])    
  end

  def create
    @squad = Squad.new(params[:squad])
    @cup = Cup.find(params[:cup][:id])
     
    if @squad.save and @squad.join_squad(@cup)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @squad
    else
      render :action => 'new'
    end
  end

  def edit
    @squad = Squad.find(params[:id])
  end

  def update
    @squad = Squad.find(params[:id])
    if @squad.update_attributes(params[:squad])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @squad
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
