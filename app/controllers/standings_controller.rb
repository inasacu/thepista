class StandingsController < ApplicationController
  before_filter :require_user
  before_filter :standing_cup
  
  def index
    render :template => '/standings/show'
  end
    
  def standing_cup
    @cup = Cup.find(params[:id])
    @standings = Standing.cup_escuadras_standing(@cup)
  end

end

