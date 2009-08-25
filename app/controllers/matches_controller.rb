class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :get_match_and_user_x_two, :only =>[:set_status, :set_team]
  
  def index
    redirect_to :controller => 'schedules', :action => 'index'
  end

  def edit
    @schedule = Schedule.find(params[:id]) 
    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
    @match = @schedule.matches.first   
    @matches = @schedule.the_roster
  end

  def update
    @match = Match.find(params[:id])
    unless current_user.is_manager_of?(@match.schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    if @match.update_attributes(params[:match])
      Match.save_matches(@match, params[:match][:match_attributes]) if params[:match][:match_attributes]
      Match.update_match_details(@match, current_user)
      
      flash[:notice] = I18n.t(:successful_update)
      redirect_to :controller => 'schedules', :action => 'show', :id => @match.schedule
    else
      render :action => 'edit'
    end
  end  
  
  def set_status
    @type = Type.find(params[:type])

    played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

    if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.now)
      Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
      # Match.log_activity_convocado(@match)

      flash[:notice] = I18n.t(:is_available_user) 
    end 

    select case @type.id
    when 1
      redirect_to :controller => 'schedules', :action => 'team_roster', :id => @match.schedule_id
      return
    when 2
      redirect_to :controller => 'schedules', :action => 'team_last_minute', :id => @match.schedule_id
      return
    when 3
      redirect_to :controller => 'schedules', :action => 'team_no_show', :id => @match.schedule_id 
      return 
    end
    redirect_back_or_default('index')
  end

  def set_team 
    unless current_user.is_sub_manager_of?(@match.schedule.group) 
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    played = (@match.type_id.to_i == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

    if @match.update_attributes(:group_id => @match.invite_id, :invite_id => @match.group_id, 
                                :played => played, :user_x_two => @user_x_two)

      Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
      flash[:notice] = I18n.t(:change_group)
    end
    redirect_back_or_default('/index')
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_match_and_user_x_two
    @match = Match.find(params[:id])

    # 1 == player is in team one
    # x == game tied, doesnt matter where player is
    # 2 == player is in team two      
    @user_x_two = "1" if (@match.group_id.to_i > 0 and @match.invite_id.to_i == 0)
    @user_x_two = "X" if (@match.group_score.to_i == @match.invite_score.to_i)
    @user_x_two = "2" if (@match.group_id.to_i == 0 and @match.invite_id.to_i > 0)
  end
end
