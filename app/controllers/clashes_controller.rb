class ClashesController < ApplicationController
  before_filter :require_user
  before_filter :get_clash_and_user_x_two, :only =>[:set_status, :set_team]
    
  def index
    redirect_to :controller => 'meets', :action => 'index'
  end

  def edit
    @clash = Clash.find(params[:id])
    @meet = @clash.meet
    @clashes = @meet.the_roster
    @tournament = @meet.round.tournament

    unless current_user.is_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end    
  end

  def update
    @clash = Clash.find(params[:id])
    @tournament = @clash.meet.round.tournament
    @meet = @clash.meet
    
    unless current_user.is_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    if @clash.update_attributes(params[:clash])
      Clash.save_clashes(@meet, params[:clash][:clash_attributes]) if params[:clash][:clash_attributes]
      Clash.update_clash_details(@meet)

      flash[:notice] = I18n.t(:successful_update)
      redirect_to :controller => 'meets', :action => 'show', :id => @clash.meet
    else
      render :action => 'edit'
    end
  end 


  def set_status
    @type = Type.find(params[:type])

    if @clash.update_attributes(:type_id => @type.id, :status_at => Time.zone.now)
      Clash.log_activity_convocado(@clash)

      flash[:notice] = I18n.t(:is_available_user) 
    end 

    select case @type.id
    when 1
      redirect_to :controller => 'meets', :action => 'tour_roster', :id => @clash.meet_id
      return
    when 2
      redirect_to :controller => 'meets', :action => 'tour_last_minute', :id => @clash.meet_id
      return
    when 3, 4
      redirect_to :controller => 'meets', :action => 'tour_no_show', :id => @clash.meet_id 
      return
    end
    redirect_back_or_default('index')
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@meet.round)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_clash_and_user_x_two
    @clash = Clash.find(params[:id])
  end
end
