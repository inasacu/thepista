class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, :openid, :success]

  before_filter :get_home,        :only => [:index]
  before_filter :get_upcoming,    :only => [:index, :upcoming, :search]

  def privacy_policy
    render :template => '/home/terms_of_use'    
  end
  
  def search
    @item_results = Search.new(params[:search])  
  end

  private
  
  def get_upcoming 
    store_location
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
    @upcoming_classifieds ||= Classified.upcoming_classifieds(session[:classified_hide_time])
    @upcoming_games ||= Game.upcoming_games(session[:game_hide_time])
    @upcoming_cups ||= Cup.upcoming_cups(session[:cup_hide_time])

    @upcoming ||=  false
    @upcoming = (!@upcoming_schedules.empty? or !@upcoming_classifieds.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
  end

  def get_home
    @items = []
    @all_items = []
    
    Teammate.latest_teammates(@all_items) 
    Cup.latest_items(@all_items)
    Group.latest_items(@all_items)
    Classified.latest_items(@all_items)
    Schedule.latest_items(@all_items)
    Challenge.latest_items(@all_items)    
    Schedule.latest_matches(@all_items)    
    Game.latest_items(@all_items)
    Group.latest_updates(@all_items)
    User.latest_updates(@all_items)  
    
    if current_user
      Comment.latest_items(@all_items, current_user)
      Match.latest_items(@all_items, current_user)
    end

    @all_items = @all_items.sort_by(&:created_at).reverse!    
    @all_items[0..GLOBAL_FEED_SIZE].each {|item| @items << item }
  end

end