class AnnouncementsController < ApplicationController
  before_filter :require_user
  # before_filter :the_maximo

  def hide_announcement
    session[:announcement_hide_time] = Time.now
  end

  def index
    @announcements = Announcement.paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def new
    @announcement = Announcement.new
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
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @announcement
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
