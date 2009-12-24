class ClassifiedsController < ApplicationController
  before_filter :require_user

  before_filter :get_classified, :only => [:show, :edit, :update, :destroy]
  before_filter :get_group, :only =>[:index, :new]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]

  def index
    @classifieds = Classified.find_classifieds(current_user, params[:page])
  end
  
  def show
    store_location    
  end

  def new
    @classified = Classified.new
    @classified.starts_at = Time.zone.now
    @classified.ends_at = Time.zone.now + 7.days

    if @group
      @classified.group_id = @group.id
      @classified.time_zone = @group.time_zone
    end

    @previous_classified = Classified.find(:first, :conditions => ["id = (select max(id) from classifieds where group_id = ?) ", @group.id])    
    unless @previous_classified.nil?
      @classified.starts_at = @previous_classified.starts_at + 7.days
      @classified.ends_at = @previous_classified.ends_at + 7.days
    end
  end

  def create
    @classified = Classified.new(params[:classified])    
    
    # has_manager_access

    if @classified.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @classified
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update    
    if @classified.update_attributes(params[:classified]) 
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @classified
    else
      render :action => 'edit'
    end
  end

  def destroy
    @classified = Classified.find(params[:id])
    @group = @classified.group
    
    @classified.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to classifieds_url
  end
 
  private
  def has_manager_access
    unless current_user.is_manager_of?(@classified.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def get_classified
    @classified = Classified.find(params[:id])
    @group = @classified.group
    @previous = Classified.previous(@classified)
    @next = Classified.next(@classified)    
  end
  
  def get_group
    # depended on number of groups for current user 
    # a group id is needed
    if current_user.groups.count == 0
      redirect_to :controller => 'groups', :action => 'new' 
      return

    elsif current_user.groups.count == 1 
      @group = current_user.groups.find(:first)

    elsif current_user.groups.count > 1 and !params[:id].nil?
      @group = Group.find(params[:id])

    elsif current_user.groups.count > 1 and params[:id].nil? 
      redirect_to :controller => 'groups', :action => 'index' 
      return
    end
    
  end
end

