class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :get_match_and_user_x_two, :only =>[:set_status, :set_team]

  def index
    redirect_to :controller => 'schedules', :action => 'index'
  end
  
  def set_match_profile
    @schedule = Schedule.find(params[:id])
    @group = @schedule.group
    @the_first_schedule = @group.schedules.first
    @matches = Match.find(:all, :joins   => "LEFT JOIN users on matches.user_id = users.id",
    :conditions => ["schedule_id = ? and user_id != ? and matches.archive = false and users.available = true and users.archive = false", @the_first_schedule, current_user],
    :order => "users.name")
    render :template => 'groups/set_profile'       
  end
  
  def set_profile
    @schedule = Schedule.find(params[:id])
    @match = @schedule.matches.first
    @matches = @schedule.the_roster

    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
  end

  def set_user_profile
    @schedule = Schedule.find(params[:id])

    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @schedule.update_profile_from_user

    flash[:success] = I18n.t(:successful_update)
    redirect_back_or_default('/index')
  end

  def rate
    @match = Match.find(params[:id])
    @match.rate(params[:stars], current_user, params[:dimension])
    id = "ajaxful-rating-#{!params[:dimension].blank? ? "#{params[:dimension]}-" : ''}match-#{@match.id}"
    render :update do |page|
      page.replace_html id, ratings_for(@match, :wrap => false, :dimension => params[:dimension], :small_stars => true)
      page.visual_effect :highlight, id
    end
  end
  
  # def rate
  #   @match = Match.find(params[:id])
  #   @match.rate(params[:stars], current_user, params[:dimension])
  #   render :update do |page|
  #     page.replace_html @match.wrapper_dom_id(params), ratings_for(@match, params.merge(:wrap => false))
  #     page.visual_effect :highlight, @match.wrapper_dom_id(params)
  #   end
  # end

  def edit
    @match = Match.find(params[:id])
    @match.description = nil
    @schedule = @match.schedule
    @matches = @schedule.the_roster

    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
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

      flash[:success] = I18n.t(:successful_update)
      redirect_to :controller => 'schedules', :action => 'show', :id => @match.schedule
    else
      render :action => 'edit'
    end
  end 

  def set_status
    unless current_user == @match.user or current_user.is_manager_of?(@match.schedule.group) 
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end

    @type = Type.find(params[:type])

    played = (@type.id == 1 and !@match.group_score.nil? and !@match.invite_score.nil?)

    if @match.update_attributes(:type_id => @type.id, :played => played, :user_x_two => @user_x_two, :status_at => Time.zone.now)
      Scorecard.calculate_user_played_assigned_scorecard(@match.user, @match.schedule.group)
      # Match.log_activity_convocado(@match)

      flash[:success] = I18n.t(:is_available_user) 
    end 

    select case @type.id
    when 1
      redirect_to :controller => 'schedules', :action => 'team_roster', :id => @match.schedule_id
      return
    when 2
      redirect_to :controller => 'schedules', :action => 'team_last_minute', :id => @match.schedule_id
      return
    when 3, 4
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
