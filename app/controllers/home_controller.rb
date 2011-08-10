require 'rubygems'
require 'rqrcode'
require 'ym4r_gm'

class HomeController < ApplicationController  
  before_filter :require_user, :except => [:index, :about, :help, :welcome, :pricing, :about, :terms_of_use, :privacy_policy, :faq, :openid, :success, :blog]

  before_filter :get_home,        :only => [:index]
  before_filter :get_upcoming,    :only => [:upcoming, :search, :index]
  before_filter :get_map,         :only => [:index]

  def index
    store_location
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
    @upcoming_classifieds ||= Classified.upcoming_classifieds(session[:classified_hide_time]) if DISPLAY_CLASSIFIEDS

    @upcoming ||=  false
    # @upcoming = (!@upcoming_schedules.empty? or !@upcoming_classifieds.empty? or !@upcoming_cups.empty? or !@upcoming_games.empty?)
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
    
    @requested_teammates = []    
    
    Teammate.latest_teammates(@all_items)     
    Group.latest_items(@all_items)   
    Venue.latest_items(@all_items) if development?
    
    Schedule.latest_matches(@all_items) 
    Reservation.latest_items(@all_items) if development?
    
    Group.latest_updates(@all_items)   
    User.latest_updates(@all_items)      
    Classified.latest_items(@all_items) if DISPLAY_CLASSIFIEDS
    
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
      Match.last_minute_items(@all_match_items, current_user) if development?
      
      Teammate.my_groups_petitions(@requested_teammates, current_user)
      Teammate.my_challenges_petitions(@requested_teammates, current_user)      
    end

    @all_items = @all_items.sort_by(&:created_at).reverse!    
    @all_items[0..MEDIUM_FEED_SIZE].each {|item| @items << item }
    
    @all_schedule_items = @all_schedule_items.sort_by(&:created_at).reverse!    
    @all_schedule_items[0..MEDIUM_FEED_SIZE].each {|item| @schedule_items << item }
    
    @all_match_items = @all_match_items.sort_by(&:created_at).reverse!    
    @all_match_items[0..EXTENDED_FEED_SIZE].each {|item| @match_items << item }
    
  end

  def get_map
    @markers = Marker.all_markers
    
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    # @map.center_zoom_init(@coord, 12)
        
     #  # Define the start and end icons  
     # @map.icon_global_init( GIcon.new( :image => "/images/pin_icon.png", 
     #                                        :icon_size => GSize.new(24,24), 
     #                                        :icon_anchor => GPoint.new(12,38), 
     #                                        :info_window_anchor => GPoint.new(9,2) ), "icon")  
     #    
     #  icon = Variable.new("icon")
     # :icon => icon
     
    @markers.each do |marker|
       
      the_groups = "<br /><strong>" + I18n.t(:groups) + ":</strong><br />" unless marker.groups.empty?
      
      marker.groups.each do |group|
        group_url = url_for(:controller => 'groups', :action => 'show', :id => group.id)   
        the_groups = the_groups + "<a href=\"#{group_url}\">#{group.name}</a>&nbsp;&nbsp;#{group.sport.name}<br />"
      end
        
      theMarker = GMarker.new([marker.latitude, marker.longitude], 
                              :info_window => "<strong>#{marker.name}</strong><br />
                                              #{marker.address}<br >
                                              #{marker.city}, #{marker.zip}<br />
                                              #{the_groups}",
                              :title => marker.name)
      @map.overlay_init(theMarker)
    end  
    @map.overlay_init(@marker) if @marker
  end
  
end