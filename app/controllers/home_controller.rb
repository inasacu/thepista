class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing]

  before_filter :get_user_mates

  def index

    if current_user
      # @feed = current_user.activities
      # @users = current_user.find_mates

      if current_user.current_login_at >= (Time.now - 1.minutes)
        @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
        redirect_to :upcoming_schedule unless @upcoming_schedules.empty? 
        return
      end
    end    
    respond_to do |format|
      format.html
      format.atom
    end  
  end

  def upcoming_schedule
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
  end

  private
  def get_user_mates
    @users = current_user.find_mates
  end

end
