class HolidaysController < ApplicationController
  before_filter :require_user    
  before_filter :get_holiday, :only => [:show, :edit, :update]
  before_filter :has_manager_access, :only => [:edit, :update]
  
  def index
    @holidays = Holiday.paginate(:all, :conditions => ["starts_at >= ? and archive = false", Time.zone.now], :page => params[:page], :order => 'name') 
  end

  def show
    store_location 
  end

  def new
    @holiday = Holiday.new
    @holiday.starts_at = Time.zone.now.change(:hour => 0, :min => 0, :sec => 0)
    @holiday.ends_at  = Time.zone.now.change(:hour => 23, :min => 59, :sec => 59)
  end

  def create
    @holiday = Holiday.new(params[:holiday])		
    @user = current_user

    if @holiday.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @holiday
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @holiday.update_attributes(params[:holiday]) 
      flash[:success] = I18n.t(:successful_update)
      redirect_to @holiday
    else
      render :action => 'edit'
    end
  end 

  private
  def get_holiday
    @holiday = Holiday.find(params[:id])
  end

  def has_manager_access
    unless current_user.is_manager_of?(@holiday)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
end