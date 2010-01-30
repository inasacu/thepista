class ClassifiedsController < ApplicationController
  before_filter :require_user

  def index
    if params[:id]
      @group = Group.find(params[:id])
      # unless current_user.is_manager_of?(@group) 
      #   flash[:warning] = I18n.t(:unauthorized)
      #   redirect_to root_url
      #   return
      # end

      @classifieds = Classified.find_classifieds(@group, params[:page])

    else
      redirect_to root_url
      return
    end

    respond_to do |format|
      format.html 
    end 
  end

  def new
    @classified = Classified.new

    return unless (params[:id])
    @group = Group.find(params[:id])

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @classified.table = @group

    @previous_classified = Classified.find(:first, 
    :conditions => ["id = (select max(id) from classifieds where table_id = ? and table_type = ?) ", @group.id, @group.class.to_s])

    unless @previous_classified.nil?
      @classified.starts_at = @previous_classified.starts_at + 7.days
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @classified = Classified.new(params[:classified]) 
    @classified.ends_at = @classified.starts_at + 7.days
    
    @group = Group.find(@classified.table_id) if @classified.table_type == "Group"
    
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    
    @classified.time_zone = @group.time_zone

    if @classified.save      
      flash[:notice] = I18n.t(:successful_create)
      redirect_to classifieds_url and return
    else
      render :action => 'new'
    end
  end
  
  def show
    @classified = Classified.find(params[:id])    
    @group = Group.find(@classified.table_id) if @classified.table_type == "Group"
  end

  def edit
    @classified = Classified.find(params[:id])    
    @group = Group.find(@classified.table_id) if @classified.table_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

  end

  def update
    @classified = Classified.find(params[:id])   
    @group = Group.find(@classified.table_id) if @classified.table_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @classified.update_attributes(params[:classified])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to classifieds_url and return
    else
      render :action => 'edit'
    end
  end

  def destroy    
    @classified = Classified.find(params[:id])   
    @group = Group.find(@classified.table_id) if @classified.table_type == "Group"

    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    @classified.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to classifieds_url
  end
end