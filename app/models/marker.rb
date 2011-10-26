class Marker < ActiveRecord::Base

  # index{ name }

  belongs_to      :item,           :polymorphic => true
  has_many        :groups
  has_one         :venue

  acts_as_mappable     :default_units => :kms

  validates_presence_of   :name, :latitude, :longitude, :lat, :lng

  # variables to access
  attr_accessible :name, :latitude, :longitude, :lat, :lng, :phone, :address, :city, :region, :zip, :description

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  # example
  # acts_as_mappable :default_units => :miles, 
  #                  :default_formula => :sphere, 
  #                  :distance_field_name => :distance,
  #                  :lat_column_name => :lat,
  #                  :lng_column_name => :lng

  has_many   :groups, 
  :conditions => "groups.archive = false",
  :order => "name"

  has_many   :sports, 
  :through => :groups,
  :order => "name"

  def self.all_markers
    find(:all, :select => "distinct markers.*", :joins => "left join groups on groups.marker_id = markers.id", 
    :conditions => "markers.archive = false", :limit => DISPLAY_MAP_POINTS)
  end

  def self.get_markers_within_local(lat, lng)
    find(:all, :select => "distinct markers.*", :joins => "left join groups on groups.marker_id = markers.id", 
    :conditions => "markers.archive = false", :origin =>[lat, lng], :within => NUMBER_LOCAL_KM, :limit => DISPLAY_MAP_POINTS)
  end

  def self.get_markers_within_national(lat, lng)
    find(:all, :origin =>[lat, lng], :within => NUMBER_NATIONAL_KM, :limit => DISPLAY_MAP_POINTS)
  end

  def self.get_markers_within_meters(lat, lng)
    find(:all, :origin =>[lat, lng], :within => NUMBER_LOCAL_METER)
  end

  def self.marker_name(user, marker="Null")
    if user.city_id > 0 
      find(:all, :select => "distinct markers.*", :conditions =>[ "markers.archive = false and (upper(markers.city) = upper(?) or markers.id = ?)", user.city.name, marker], 
                 :order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
    else
      find(:all, :select => "distinct markers.*", :joins => "join groups on groups.marker_id = markers.id").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
    end
  end  

  def my_sports
    @my_sports = []
    self.sports.each { |sport| @my_sports << sport.id unless @my_sports.include?(sport.id) } 
    Sport.find(:all, :conditions => ["id in (?)", @my_sports], :order => "sports.name")
  end
end