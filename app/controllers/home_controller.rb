class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing]

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

end
