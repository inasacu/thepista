require 'ym4r_gm'

class MarkersController < ApplicationController
  before_filter :require_user
  # before_filter :the_maximo,            :only => [:full_list, :edit, :update]
  before_filter :the_maximo,            :only => [:edit, :update]

  before_filter :get_marker,            :only => [:edit, :update]
  before_filter :get_complete_markers,  :only => [:list]
  before_filter :get_my_markers,        :only => [:index, :original, :direction]
  before_filter :get_list_markers,      :only => [:search]
  before_filter :get_all_markers,       :only => [:index, :list, :search, :direction]

  include GeoKit::Geocoders

  def index
    # @coord = [40.4166909, -3.7003454]
    @coord = [NUMBER_LATITUDE, NUMBER_LONGITUDE]
    if @location.success
      @coord =  [@location.lat, @location.lng]  
    end

    location = "#{current_user.time_zone.to_s}"

    results = Geocoding::get(location)
    if results.status == Geocoding::GEO_SUCCESS
      @coord = results[0].latlon
      @marker = GMarker.new(@coord, :info_window => location, :title => location)
    end

    @markers = Marker.all_markers

    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(@coord, 12)

    @markers.each do |marker|
      the_new_model_url = ""

      the_groups = "<br /><strong>" + I18n.t(:groups) + ":</strong><br />" unless marker.groups.empty?

      marker.groups.each do |group|
        group_url = url_for(:controller => 'groups', :action => 'show', :id => group.id)   
        the_groups = the_groups + "<a href=\"#{group_url}\">#{group.name}</a>&nbsp;&nbsp;#{group.sport.name}<br />"
      end    

      the_new_model_url = "<br /><strong>" + I18n.t(:create) + ":</strong><br />"
      the_group_url = url_for(:controller => 'groups', :action => 'new', :marker_id => marker)

      the_new_model_url = the_new_model_url + "<a href=\"#{the_group_url}\">#{I18n.t(:you_are_create_group)}</a>&nbsp;&nbsp;"

      theMarker = GMarker.new([marker.latitude, marker.longitude], 
      :info_window => "<strong>#{marker.name}</strong><br />
      #{marker.address}<br >
      #{marker.city}, #{marker.zip}<br />
      #{the_groups}<br/><br/>#{the_new_model_url}",
      :title => marker.name)
      @map.overlay_init(theMarker)
    end  
    @map.overlay_init(@marker) if @marker   
  end

  def direction
    @default_min_points = 0
    @default_max_points = 25
    @default_zoom = 8
    render :template => "markers/index_gmap3"
  end

  def search
    @default_min_points = 0
    @default_max_points = 25
    @default_zoom = 10
    render :template => "markers/index_gmap3"
  end

  def show
    @marker = Marker.find(params[:id])
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@marker.latitude, @marker.longitude], 15)
    @marker = Marker.find(:all, :conditions => "latitude is not null and longitude is not null and archive = false").each do |marker|
      theMarker = GMarker.new([marker.latitude, marker.longitude], :title => marker.name, :info_window =>  marker.name + "! ") 
      @map.overlay_init(theMarker)
    end  
    render :template => '/markers/index'  
  end
  
  def full_list
    @markers = Marker.paginate(:all, :conditions => ["archive = false"], :order => "markers.name DESC", :page => params[:page], :per_page => MARKERS_PER_PAGE)
  end
  
  # def show
  #   @default_min_points = 0
  #   @default_max_points = 35
  #   @default_zoom = 10
  #   render :template => "markers/index_gmap3"
  # end

  def list
    @default_zoom = 5
    render :template => "markers/index_gmap3"
  end

  def new
    if params[:lat] and params[:lng] 
      @marker = Marker.new()
      @location = GoogleGeocoder.reverse_geocode([params[:lat], params[:lng]]) 

      @near_markers = Marker.get_markers_within_meters(params[:lat], params[:lng])

      @marker.latitude = params[:lat]
      @marker.longitude = params[:lng]

      @marker.lat = params[:lat]
      @marker.lng = params[:lng]

      @marker.address = @location.street_address
      @marker.city = @location.city
      @marker.region = @location.state
      @marker.zip = @location.zip

    else
      redirect_to markers_url
      return
    end
  end

  def create
    @marker = Marker.new(params[:marker])	

    @location = GoogleGeocoder.reverse_geocode([@marker.latitude, @marker.longitude])  

    @marker.address = @location.street_address
    @marker.city = @location.city
    @marker.region = @location.state
    @marker.zip = @location.zip

    @marker.item = current_user

    if @marker.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to markers_url
    else
      render :action => 'new'
    end
  end

  def edit
    @marker = Marker.find(params[:id])
  end

  def update
    @marker.lat = @marker.latitude
    @marker.lng = @marker.longitude
        
    if @marker.update_attributes(params[:marker])
      flash[:success] = I18n.t(:successful_update)
      redirect_to markers_url
      return
    else
      render :action => 'edit'
    end
  end

  private
  def get_complete_markers
    if (current_user.current_login_ip != '127.0.0.1')
      @location = IpGeocoder.geocode(current_user.current_login_ip)
    else
      @location = GoogleGeocoder.geocode(current_user.city.name)
    end
    @markers = Marker.all_markers
  end

  def get_my_markers      
    if (current_user.current_login_ip != '127.0.0.1')
      @location = IpGeocoder.geocode(current_user.current_login_ip)
    else
      @location = GoogleGeocoder.geocode(current_user.city.name)
    end  

    if (params[:id])
      simple_marker = Marker.find(params[:id])      
      @markers = Marker.get_markers_within_local(simple_marker.lat, simple_marker.lng)

    else

      if (@location.lat.nil? or @location.lng.nil?)
        @markers = Marker.all_markers
      else
        @markers = Marker.get_markers_within_local(@location.lat, @location.lng)
      end
    end
  end

  def get_list_markers
    if (current_user.current_login_ip != '127.0.0.1')
      @location = IpGeocoder.geocode(current_user.current_login_ip)
    else
      @location = GoogleGeocoder.geocode(current_user.city.name)
    end


    if (params[:id])
      simple_marker = Marker.find(params[:id])  
      @markers = Marker.get_markers_within_national(simple_marker.lat, simple_marker.lng)    
    else
      if (@location.lat.nil? or @location.lng.nil?)
        @markers = Marker.all_markers
      else
        @markers = Marker.get_markers_within_national(@location.lat, @location.lng)
      end
    end
  end

  def get_all_markers    
    @the_markers = []    
    
    @default_latitude = NUMBER_LATITUDE
    @default_longitude = NUMBER_LONGITUDE

    @default_latitude = @location.lat unless @location.lat.nil?
    @default_longitude = @location.lng unless @location.lng.nil?

    has_access = current_user.is_maximo?

    @markers.each do |marker|  

      the_groups = ""  
      the_new_model_url = ""
      the_group_url = ""
      the_installation_url = ""
      the_venue_url = ""

      the_groups = "<br /><strong>" + I18n.t(:groups) + ":</strong><br />" unless marker.groups.empty?

      marker.groups.each do |group|
        group_url = url_for(:controller => 'groups', :action => 'show', :id => group.id)   
        the_groups = the_groups + "<a href=\"#{group_url}\">#{group.name}</a>&nbsp;&nbsp;#{group.sport.name}<br />"
      end      
      the_groups = "#{the_groups}<br/>"


      if has_access
        the_new_model_url = "<br /><strong>" + I18n.t(:create) + ":</strong><br />"
        # the_installation_url = url_for(:controller => 'installations', :action => 'new', :marker_id => marker)
        the_venue_url = url_for(:controller => 'venues', :action => 'new', :marker_id => marker)

        # the_new_model_url = the_new_model_url + "<a href=\"#{the_installation_url}\">#{I18n.t(:you_are_create_installation)}</a><br/>"
        the_new_model_url = the_new_model_url + "<a href=\"#{the_venue_url}\">#{I18n.t(:you_are_create_venue)}</a>"

      else
        the_new_model_url = "<br /><strong>" + I18n.t(:create) + ":</strong><br />"
        the_group_url = url_for(:controller => 'groups', :action => 'new', :marker_id => marker)

        the_new_model_url = the_new_model_url + "<a href=\"#{the_group_url}\">#{I18n.t(:you_are_create_group)}</a>&nbsp;&nbsp;"
      end


      @the_markers << Marker.new(:latitude => marker.latitude, :longitude => marker.longitude, 
      :description => "<strong>#{marker.name}</strong><br/>#{marker.address}<br/>#{marker.city}, #{marker.zip}<br/>#{the_groups}<br/>#{the_new_model_url}",
      :name => marker.name)
    end

  end
  
  def get_marker
    @marker = Marker.find(params[:id])  
  end

  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end

end

