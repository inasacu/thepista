require 'ym4r_gm'
require 'test/unit'
class MarkersController < ApplicationController

  def index
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([40.41562,-3.682222], 11)
    @markers = Marker.find(:all, :conditions => "latitude is not null and longitude is not null").each do |marker|
      theMarker = GMarker.new([marker.latitude, marker.longitude], :title => marker.name, :info_window =>  marker.name + "! ") 
      @map.overlay_init(theMarker)
    end  
  end

  def show
    @marker = Marker.find(params[:id])
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@marker.latitude, @marker.longitude], 15)
    @marker = Marker.find(:all, :conditions => "latitude is not null and longitude is not null").each do |marker|
      theMarker = GMarker.new([marker.latitude, marker.longitude], :title => marker.name, :info_window =>  marker.name + "! ") 
      @map.overlay_init(theMarker)
    end  
    render :template => '/markers/index'  
  end

  def show_list
    @markers = Marker.find(:all)
  end 

  def new 
    # render :template => '/markers/form'
  end

  def get_locate
    labels = [I18n.t(:name),I18n.t(:address),I18n.t(:city),I18n.t(:zip)]    
    render :text=> labels.to_json
  end

  def list
    render :text=>(Marker.find :all).to_json
  end

  
  def create   
    @marker = Marker.new(params[:marker])
    if @marker.save      

      # @marker.accepts_role 'creator', current_user
      action = "../../groups/new/#{@marker.id}"
      res={:success=>true,
        :icon => "../../images/#{@marker.icon}" ,
        :content =>"<div><strong>#{I18n.t(:name)}:&nbsp;&nbsp;</strong>#{@marker.name}</div>" +
        "<div><strong>#{I18n.t(:address)}:&nbsp;&nbsp;</strong>#{@marker.address}</div>" +
        "<div><strong>#{I18n.t(:city)}:&nbsp;&nbsp;</strong>#{@marker.city}</div>" +
        "<div><strong>#{I18n.t(:zip)}:&nbsp;&nbsp;</strong>#{@marker.zip}</div>" +
        "<div><strong><a href=\"#{action}\">#{I18n.t(:url_group)}</a></strong></div>"}
        render :text=>res.to_json
        
      else
        res={:success=>false, :content=>"#{I18n.t(:marker)} #{I18n.t(:not_created)}"}
      end
      # render :text=>res.to_json
    end

    def search
      @markers = Marker.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
      render :template => '/markers/index'
    end

    def edit  
      # editing is limited to maximo or creator
      permit "maximo or creator of :marker ", :marker => Marker.find(params[:id].to_i) do 
        @marker = Marker.find(params[:id])
        render :template =>  '/markers/edit' 
      end
    end

    def update  
      # updating is limited to maximo or creator or manager
      permit "maximo or creator or manager of :marker ", :marker => Marker.find(params[:id].to_i) do       
        @marker = Marker.find(params[:id])
        @marker.url = "http://local.google.com/markers?q=" + 
        (@marker.address + " " + @marker.city + " " + @marker.zip).gsub(" ", "+")

        if @marker.update_attributes(params[:marker])
          flash[:notice] = "#{t(:marker) } #{t(:updated)}"
          redirect_to :controller => 'marker', :action => 'index'
          return
        else
          flash[:notice] = "#{t(:marker) } #{t(:not_updated)}"
          reder :action => 'edit'
        end
      end
    end



  end
