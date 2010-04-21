class StandingsController < ApplicationController
  before_filter :require_user
  before_filter :standing_cup, :only => [:index, :show]
  
  def index
    render :template => '/standings/show'
  end
  
  def set_stand_group_stage_name
      @standing = Standing.find(params[:id])
      @cup = @standing.cup
      
      unless current_user.is_manager_of?(@cup)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
      
      group_stage_name = params[:stand][:group_stage_name]
      if @standing.update_attributes('group_stage_name' => group_stage_name)
        flash[:notice] = I18n.t(:successful_update)
      end
      redirect_to standings_path(:id => @cup)
      return
  end
    
  def standing_cup
    @cup = Cup.find(params[:id])
    @standings = Standing.cup_escuadras_standing(@cup)
  end

end

