class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, :openid]
  before_filter :get_user_mates #, :get_tag
  before_filter :get_home,        :only => [:index]
  before_filter :get_upcoming,    :only => [:index, :upcoming]

  def index
  end

  def about
  end

  def terms_of_use
  end

  def privacy_policy
    render :template => '/home/terms_of_use'    
  end

  def faq
  end

  def openid
  end

  private
  def get_user_mates
    @users = current_user.find_mates if current_user
    @has_activities = Activity.all_activities(current_user) if current_user

    @my_activities = Activity.related_activities(current_user) if @has_activities
    @my_activities = Activity.current_activities unless @has_activities
  end

  # def get_tag    
  #   # @tags = Schedule.tag_counts_on(:tags, :at_least => TAG_LEAST, :limit => TAG_LIMIT, :order => "name")
  # end

  def get_upcoming 
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
    @upcoming_classifieds ||= Classified.upcoming_classifieds(session[:classified_hide_time])
    @upcoming_games ||= Game.upcoming_games(session[:game_hide_time])
    @upcoming_cups ||= Cup.upcoming_cups(session[:cup_hide_time])

    @upcoming ||=  false
    @upcoming = (!@upcoming_schedules.empty? or !@upcoming_classifieds.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
  end

  def get_home
    @items = []
    
    Teammate.latest_teammates(@items) 
    Cup.latest_items(@items)
    Group.latest_items(@items) 
    Schedule.latest_items(@items)
    Challenge.latest_items(@items)    
    Schedule.latest_matches(@items)    
    Game.latest_items(@items)    

    # @items.sort { |a,b| a.created_at <=> b.created_at }.reverse!
    @items = @items.sort_by(&:created_at).reverse!
  end

end