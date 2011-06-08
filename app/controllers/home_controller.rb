class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, :openid, :success, :blog]

  before_filter :get_home,        :only => [:index]
  before_filter :get_upcoming,    :only => [:upcoming, :search]

  def index
    store_location
    # unless current_user
    # 
    #   redirect_to(:controller => 'user_sessions', :action => 'new')
    #   return
    # end
  end
  
  def privacy_policy
    render :template => '/home/terms_of_use'    
  end
  
  def search
    @item_results = []
    @all_items =  Search.new(params[:search])   
    @all_items[0..LARGE_FEED_SIZE].each {|item| @item_results << item }
  end

  private
  
  def get_upcoming 
    store_location
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
    @upcoming_cups ||= Cup.upcoming_cups(session[:cup_hide_time])
    @upcoming_games ||= Game.upcoming_games(session[:game_hide_time])
    @upcoming_classifieds ||= Classified.upcoming_classifieds(session[:classified_hide_time])

    @upcoming ||=  false
    @upcoming = (!@upcoming_schedules.empty? or !@upcoming_classifieds.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
  end

  def get_home    
    @items = []
    @all_items = []
    
    @has_values = false
    
    @match_items = []
    @all_match_items = []
    
    @schedule_items = []
    @all_schedule_items = []
    
    @my_schedules = []
    
    Teammate.latest_teammates(@all_items)     
    Group.latest_items(@all_items)   
    # Venue.latest_items(@all_items)  
    
    Schedule.latest_matches(@all_items) 
    Reservation.latest_items(@all_items) if development?
    
    Group.latest_updates(@all_items)   
    User.latest_updates(@all_items)      
    Classified.latest_items(@all_items)
    
    Cup.latest_items(@all_items, @has_values)    
    if @has_values
      Challenge.latest_items(@all_items)  
      Game.latest_items(@all_items)
    end

    Schedule.latest_items(@all_schedule_items)    
    
    if current_user
      @my_schedules = Schedule.my_current_schedules(current_user)
      
      current_user.groups.each {|group| Scorecard.latest_items(@all_items, group)}
      
      Comment.latest_items(@all_match_items, current_user)
      Match.latest_items(@all_match_items, current_user)
      Match.last_minute_items(@all_match_items, current_user)
    end

    @all_items = @all_items.sort_by(&:created_at).reverse!    
    @all_items[0..MEDIUM_FEED_SIZE].each {|item| @items << item }
    
    @all_schedule_items = @all_schedule_items.sort_by(&:created_at).reverse!    
    @all_schedule_items[0..MEDIUM_FEED_SIZE].each {|item| @schedule_items << item }
    
    @all_match_items = @all_match_items.sort_by(&:created_at).reverse!    
    @all_match_items[0..EXTENDED_FEED_SIZE].each {|item| @match_items << item }
    
  end

end