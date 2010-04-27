class StagesController < ApplicationController
  before_filter :require_user
  # before_filter :the_maximo

  def index    
    @cup = Cup.find(params[:id])
    @stages = @cup.stages
  end

  def list    
    @cup = Cup.find(params[:id])
    @stages = @cup.stages
    render :template => '/stages/index'
  end
  
  def show
    @stage = Stage.find(params[:id])
    @cup = @stage.cups.first
    redirect_to list_stages_path(:id => @cup)    
    return
  end

  def new
    @stage = Stage.new
    @cup = Cup.find(params[:id])    
    
    @stage.cup_id = @cup.id

    if @cup
      @previous_stage = Stage.find(:first, :conditions => ["id = (select max(id) from stages where cup_id = ?) ", @cup.id])    
      unless @previous_stage.nil?
        @stage.home_ranking = @previous_stage.home_ranking
        @stage.away_ranking = @previous_stage.away_ranking 
      end
    end
    
  end

  def create
    @stage = Stage.new(params[:stage])
    # @cup = Cup.find(params[:cup][:id])
    
    @cup = Cup.find(@stage.cup_id)
    @stage.name = @cup.name
    
    # @stage.cup_id = @cup.id
    # @stage.home_stage_name = @stage.home_stage_name.upcase
    # @stage.away_stage_name = @stage.away_stage_name.upcase
     
    if @stage.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to stages_path(:id => @cup) and return
    else
      render :action => 'new'
    end
  end

  def edit
    @stage = Stage.find(params[:id])
    @cup = @stage.cups.first
  end

  def update
    @stage = Stage.find(params[:id])
    if @stage.update_attributes(params[:stage])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @stage
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
