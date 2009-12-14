class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about_us, :terms_of_use, :privacy_policy, :faq]
  before_filter :get_user_mates

  def index
    if current_user
        
      @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
      # @upcoming_meets ||= Meet.upcoming_meets(session[:meet_hide_time]) if development?
      
      unless @upcoming_schedules.empty?       
      # if current_user.current_login_at >= (Time.zone.now - 1.minutes)            
        # redirect_to :upcoming_schedule 
        redirect_to :upcoming
        return
      end
      
    end    
    
    respond_to do |format|
      format.html
      format.atom
    end  
  end
  
  def upcoming
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
    # @upcoming_meets ||= Meet.upcoming_meets(session[:meet_hide_time]) if development?    
  end

  # def upcoming_schedule
  #   @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
  #   @upcoming_meets ||= Meet.upcoming_meets(session[:meet_hide_time]) if development?
  # end
  
  def about_us
  end
  
  def terms_of_use
  end
  
  def privacy_policy
    render :template => '/home/terms_of_use'    
  end
  
  def faq
  end
  
  private
  def get_user_mates
    @users = current_user.find_mates if current_user
    @has_activities = Activity.all_activities(current_user) if current_user
  end

end
