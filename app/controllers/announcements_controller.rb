class AnnouncementsController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo, :only => [:index, :list, :show, :new, :create, :edit, :update,  :destroy] 
  
  def index
    @announcements = Announcement.paginate(:per_page => SCHEDULES_PER_PAGE, :page => params[:page])
	render @the_template
  end
  
  def list
    @announcements = Announcement.previous_announcement
    set_the_template('announcements/index')
	render @the_template
  end

  def show
    @announcement = Announcement.find(params[:id])
	render @the_template
  end

  def new
    @announcement = Announcement.new
    @announcement.ends_at = Time.zone.now + 1.day
	render @the_template
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @announcement
    else
      render :action => 'new'
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
	render @the_template
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      flash[:success] = I18n.t(:successful_update)
      redirect_to @announcement
    else
      render :action => 'edit'
    end
  end

    def destroy
      @announcement = Announcement.find(params[:id])
      @announcement.destroy
      flash[:success] = I18n.t(:successful_update)
      redirect_to announcement_url
    end

  private 
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end
end
