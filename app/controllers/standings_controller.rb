class StandingsController < ApplicationController
  before_filter :require_user
  before_filter :standing_cup, :only => [:index, :show]
  before_filter :standing_challenge, :only => [:show_list]
  
  def show
    render :template => '/standings/index'
  end
  
  def show_list
    render :template => '/standings/index'
  end
  
  def show_all
    @cup = Cup.find(params[:id])
    @standings = Standing.cup_items_standing(@cup, current_user)
    render :template => '/standings/index'
  end
  
  def set_group_stage
    @cup = Cup.find(params[:id])
    @standings = Standing.cup_escuadras_standing(@cup)
    @standing = @standings.first
    
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
  end

  def update
    @standing = Standing.find(params[:id])
    @cup = @standing.cup
    
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    if @standing.update_attributes(params[:standing])
      Standing.save_standings(@standing, params[:standing][:standing_attributes]) if params[:standing][:standing_attributes]

      flash[:success] = I18n.t(:successful_update)
      redirect_to standings_path(:id => @cup)
    else
      render :action => 'edit'
    end
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
      if @standing.update_attributes('group_stage_name' => group_stage_name.upcase)
        flash[:success] = I18n.t(:successful_update)
      end
      redirect_to standings_path(:id => @cup)
      return
  end
  
  def standing_challenge
    @challenge = Challenge.find(params[:id])
    @standings = Standing.cup_challenge_users_standing(@challenge)
    @cup = @challenge.cup    
  end
  
  def standing_cup
    @cup = Cup.find(params[:id])
    @standings = Standing.cup_escuadras_standing(@cup)
  end

end

