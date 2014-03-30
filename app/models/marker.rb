# == Schema Information
#
# Table name: markers
#
#  id          :integer          not null, primary key
#  name        :string(150)      default("")
#  latitude    :decimal(15, 10)
#  longitude   :decimal(15, 10)
#  direction   :string(255)
#  image_url   :string(255)
#  url         :string(255)
#  contact     :string(150)
#  email       :string(255)
#  phone       :string(40)
#  address     :string(255)      default("")
#  city        :string(255)      default("")
#  region      :string(40)       default("")
#  zip         :string(40)       default("")
#  surface     :string(255)
#  facility    :string(255)
#  starts_at   :datetime
#  ends_at     :datetime
#  time_zone   :string(255)      default("UTC")
#  public      :boolean          default(TRUE)
#  activation  :boolean          default(FALSE)
#  description :text
#  icon        :string(100)      default("")
#  shadow      :string(100)      default("")
#  archive     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  item_id     :integer
#  item_type   :string(255)
#  lat         :float            default(0.0)
#  lng         :float            default(0.0)
#  slug        :string(255)
#  short_name  :string(255)
#

class Marker < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged
	
  # # index{ name }

  belongs_to      :item,           :polymorphic => true
  has_many        :groups
  has_one         :venue

  acts_as_mappable     :default_units => :kms

  validates_presence_of   :name, :latitude, :longitude, :lat, :lng

  # variables to access
  attr_accessible :name, :latitude, :longitude, :lat, :lng, :phone, :address, :city, :region, :zip, :description, :slug

  has_many   :groups, 
  :conditions => "groups.archive = false",
  :order => "name"

  has_many   :sports, 
  :through => :groups,
  :order => "name"

  has_many :schedules,
  :conditions => "schedules.archive = false"

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
		if user.is_maximo?
			return find(:all, :conditions => "markers.archive = false",  :order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		end
		if user.city_id > 0 
			find(:all, :select => "distinct markers.*", 
			:conditions =>[ "markers.archive = false and (upper(markers.city) = upper(?) or markers.id = ?)", user.city.name, marker], 
			:order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		else
			return find(:all, :conditions => "markers.archive = false",  :order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		end
	end
	
	def self.simple_marker_name
		find(:all, :conditions => "markers.archive = false", :order => "markers.name").collect {|p| [ p.name, p.id ] }
	end

  def my_sports
    @my_sports = []
    self.sports.each { |sport| @my_sports << sport.id unless @my_sports.include?(sport.id) } 
    Sport.find(:all, :conditions => ["id in (?)", @my_sports], :order => "sports.name")
  end
end
