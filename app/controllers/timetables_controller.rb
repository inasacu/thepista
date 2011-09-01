class TimetablesController < ApplicationController
  before_filter :require_user

  before_filter   :get_installation,    :only => [:new, :create]
  before_filter   :get_timetable,       :only => [:edit, :update]

  def index  
    store_location
    @installations = Installation.current_installations(@venue, params[:page])
  end

  def show
    redirect_to show_installation_url(:id => @installation)
  end

  def new
    @timetable = Timetable.new
    @timetable.installation = @installation
    @timetable.starts_at = @installation.starts_at
    @timetable.ends_at = @installation.ends_at
    @timetable.timeframe = @installation.timeframe

    @previous_timetable = Timetable.find(:first, :conditions => ["id = (select max(id) from timetables where installation_id = ?) ", @installation])    
    unless @previous_timetable.nil?     
      @timetable.type_id = @previous_timetable.type_id
      @timetable.starts_at = @previous_timetable.starts_at
      @timetable.ends_at = @previous_timetable.ends_at
      @timetable.timeframe = @previous_timetable.timeframe
    end
    
  end

  def create
    @timetable = Timetable.new(params[:timetable])  

    if @timetable.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @installation
    else
      render :action => 'new'
    end
  end

  def update
    if @timetable.update_attributes(params[:timetable])  
      flash[:success] = I18n.t(:successful_update)
      redirect_to @installation
    else
      render :action => 'edit'
    end
  end

  def set_copy_timetable
    @installation = Installation.find(params[:id])
    @current_intallation = Installation.find(params[:current_id])

    unless @installation.nil?
      @the_timetables = Timetable.installation_timetable(@installation)
      
      @the_timetables.each do |the_timetable|
        @timetable = Timetable.new
        @timetable = the_timetable
        @timetable.installation = @current_intallation
        @timetable.save
      end
      
      flash[:success] = I18n.t(:successful_update)
      redirect_to @current_intallation
      return
    end
    redirect_to root_url
  end

  private
  
  def get_timetable
    @timetable = Timetable.find(params[:id]) if params[:id]
    @installation = @timetable.installation
    @venue = @installation.venue
    
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_installation
    @installation = Installation.find(params[:id]) if params[:id]
    @installation = Installation.find(params[:timetable][:installation_id]) if params[:timetable]
    @venue = @installation.venue
    
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

end

