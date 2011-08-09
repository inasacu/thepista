require 'ym4r_gm'

class MarkersController < ApplicationController
  before_filter :require_user
  before_filter :the_maximo,      :only => [:edit, :update]

  before_filter :get_all_markers, :only => [:index, :search, :address, :show]

  include GeoKit::Geocoders

  def new
    if params[:lat] and params[:lng]
      @location = GoogleGeocoder.reverse_geocode([params[:lat], params[:lng]])  

      @marker = Marker.new()

      @marker.latitude = params[:lat]
      @marker.longitude = params[:lng]

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
    @marker = Marker.find(params[:id])
    if @marker.update_attributes(params[:marker])
      flash[:success] = I18n.t(:successful_update)
      redirect_to markers_url
      return
    else
      render :action => 'edit'
    end
  end

  private

  def get_all_markers    

    @location = IpGeocoder.geocode(current_user.current_login_ip)
    # @location = IpGeocoder.geocode('80.58.61.254')

    @the_markers = [] 
    the_groups = ""   

    if (params[:id])
      simple_marker = Marker.find(params[:id])
      # @markers = Marker.find(:all, :conditions => ["id = ?", simple_marker.id], :within => 15)  
      
      @markers = Marker.find(:all, :origin =>[37.792,-122.393], :within=>10) 

    else
      @markers = Marker.all_markers
    end

    @markers.each do |marker|      

      the_new_model_url = "<br /><strong>" + I18n.t(:create) + ":</strong><br />"

      the_group_url = url_for(:controller => 'groups', :action => 'new', :marker_id => marker)
      the_installation_url = url_for(:controller => 'installations', :action => 'new', :marker_id => marker)
      the_venue_url = url_for(:controller => 'venues', :action => 'new', :marker_id => marker)

      the_new_model_url = the_new_model_url + "<a href=\"#{the_group_url}\">#{I18n.t(:you_are_create_group)}</a>&nbsp;&nbsp;"

      if current_user.is_maximo?
        the_new_model_url = the_new_model_url + "<a href=\"#{the_installation_url}\">#{I18n.t(:you_are_create_installation)}</a><br/>"
        the_new_model_url = the_new_model_url + "<a href=\"#{the_venue_url}\">#{I18n.t(:you_are_create_venue)}</a>"
      end

      @the_markers << Marker.new(:latitude => marker.latitude, :longitude => marker.longitude, 
      :description => "<strong>#{marker.name}</strong><br/>#{marker.address}<br/>#{marker.city}, #{marker.zip}<br/>#{the_new_model_url}",
      :name => marker.name)
    end

    render :template => "markers/index_gmap3" 
  end

  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end

end

