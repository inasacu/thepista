class ChallengesController < ApplicationController
  before_filter :require_user    
  before_filter :get_challenge, :only => [:challenge_list, :show, :edit, :update, :set_automatic_petition]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]

  before_filter :get_cup, :only =>[:new]
  # before_filter :has_member_access, :only => :show
  before_filter :has_member_access, :only => [:challenge_list]
  
  def index
    @challenges = Challenge.current_challenges(params[:page])

    if @challenges.nil? or @challenges.blank?
      redirect_to :action => 'list'
      return
    end   
	render @the_template
  end

  def list
    @challenges = Challenge.paginate(:all, :conditions => ["archive = false and id not in (?)", current_user.challenges], 
    :page => params[:page], :order => 'name') unless current_user.challenges.blank?
    # @challenges = Challenge.paginate(:all, :conditions =>["archive = false"], 
    # :page => params[:page], :order => 'name') if current_user.challenges.blank?
    
    if @challenges.nil? or @challenges.blank?
      redirect_to :controller => 'cups'
      return
    end
       
    set_the_template('challenges/index')
	render @the_template  
  end

  def challenge_list
    @users = @challenge.users.paginate(:page => params[:page], :per_page => USERS_PER_PAGE)
    @total = @challenge.users.count   
    set_the_template('casts/index')
	render @the_template
  end

  def show
    store_location    
	render @the_template
  end

  def new
    @challenge = Challenge.new
    @challenge.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    
    if @cup
      @challenge.cup_id = @cup.id 
      @challenge.description = @cup.description
      @challenge.conditions = @cup.conditions
      @challenge.starts_at = @cup.starts_at
      @challenge.ends_at = @cup.ends_at
      @challenge.reminder_at = @cup.starts_at - 7.days     
    end   
	render @the_template
  end

  def create
    @challenge = Challenge.new(params[:challenge])	
    
    @cup = Cup.find(@challenge.cup_id)	
    @challenge.starts_at = @cup.starts_at
    @challenge.ends_at = @cup.ends_at
    @challenge.reminder_at = @cup.starts_at - 7.days
    @challenge.player_limit = 99
    
    if @challenge.save and @challenge.create_challenge_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @challenge
    else
      render :action => 'new'
    end
  end 
  
  def set_automatic_petition
    if @group.update_attribute("automatic_petition", !@group.automatic_petition)
      @group.update_attribute("automatic_petition", @group.automatic_petition)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end
  
  def edit
	render @the_template
	end

  def update
    @original_challenge = Challenge.find(params[:id])

    if @challenge.update_attributes(params[:challenge]) 
      flash[:success] = I18n.t(:successful_update)
      redirect_to @challenge
    else
      render :action => 'edit'
    end
  end 

  def destroy
    # @challenge = Challenge.find(params[:id])
    counter = 0
    @challenge.schedules.each {|schedule| counter += 1 }

    # @challenge.destroy unless counter > 0

    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to challenge_url
  end

  private
  def get_challenge
    @challenge = Challenge.find(params[:id]) 
    @cup = @challenge.cup
  end

  def get_cup
    @cup = Cup.find(params[:id])
  end
  
  def has_member_access
    unless current_user.is_member_of?(@challenge)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

  def has_manager_access
    unless current_user.is_manager_of?(@challenge)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end
end