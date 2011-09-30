class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, :openid, :success, :blog]

  before_filter :get_home,        :only => [:index]
  before_filter :get_upcoming,    :only => [:upcoming]

  def index
    store_location  
    # render :template => 'home/facebook_comments'
    # render :template => 'home/pricing'
    # render :template => 'home/tooltip'
  end
  
  def qr
    redirect_to root_url
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

    @upcoming ||=  false
    @upcoming = (!@upcoming_schedules.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
  end

  def get_home
    @items = []
    @all_items = []    
    @match_items = []
    @all_match_items = []    
    @schedule_items = []
    @all_schedule_items = []    
    @my_schedules = []    
    @requested_teammates = [] 
    
    @all_comment_items = []
    @comment_items = []
    
    @has_values = false   
    
    Teammate.latest_teammates(@all_items) 
    Schedule.latest_matches(@all_items) 
    Schedule.latest_items(@all_schedule_items)   
    Group.latest_items(@all_items)    
    User.latest_items(@all_items)
    
    if current_user      
      @no_linkedin_profile = (current_user.linkedin_url.nil? or current_user.linkedin_url.blank? or current_user.linkedin_url.empty?)
      
      @my_schedules = Schedule.my_current_schedules(current_user)
      
      Comment.latest_items(@all_comment_items, current_user)
      
      Match.latest_items(@all_match_items, current_user)
      Match.last_minute_items(@all_match_items, current_user) if DISPLAY_LAST_MINUTE_CANCEL
      
      Teammate.my_groups_petitions(@requested_teammates, current_user)
      Teammate.my_challenges_petitions(@requested_teammates, current_user)   
      
      current_user.groups.each {|group| Scorecard.latest_items(@all_items, group)} if DISPLAY_MAX_GAMES_PLAYED   
    end
        
    Group.latest_updates(@all_items) if @all_items.count < MEDIUM_FEED_SIZE     
    User.latest_updates(@all_items) if @all_items.count < MEDIUM_FEED_SIZE 
    Venue.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE  
    Reservation.latest_items(@all_items) if @all_items.count < MEDIUM_FEED_SIZE  

    if @all_items.count < MEDIUM_FEED_SIZE
      Classified.latest_items(@all_items) if DISPLAY_CLASSIFIEDS

      Cup.latest_items(@all_items, @has_values)    
      if @has_values
        Challenge.latest_items(@all_items)  
        Game.latest_items(@all_items)
      end
    end
    

    @all_items = @all_items.sort_by(&:created_at).reverse!    
    @all_items[0..MEDIUM_FEED_SIZE].each {|item| @items << item }
    
    @all_schedule_items = @all_schedule_items.sort_by(&:created_at).reverse!    
    @all_schedule_items[0..MEDIUM_FEED_SIZE].each {|item| @schedule_items << item }
    
    @all_comment_items = @all_comment_items.sort_by(&:created_at).reverse!    
    @all_comment_items[0..EXTENDED_FEED_SIZE].each {|item| @comment_items << item }
    
    @all_match_items = @all_match_items.sort_by(&:created_at).reverse!    
    @all_match_items[0..EXTENDED_FEED_SIZE].each {|item| @match_items << item }
    
  end
  
end