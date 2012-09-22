# TABLE "markers"
# t.string   "name"                                         
# t.decimal  "latitude"                   
# t.decimal  "longitude"                  
# t.string   "direction"
# t.string   "image_url"
# t.string   "url"
# t.string   "contact"     
# t.string   "email"
# t.string   "phone"       
# t.string   "address"                                                    
# t.string   "city"                                                       
# t.string   "region"                                        
# t.string   "zip"                                           
# t.string   "surface"
# t.string   "facility"
# t.datetime "starts_at"
# t.datetime "s_at"
# t.string   "time_zone"                                                  
# t.boolean  "public"                                                     
# t.boolean  "activation"                                                 
# t.text     "description"
# t.string   "icon"                                         
# t.string   "shadow"                                       
# t.boolean  "archive"                                                    
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "item_id"
# t.string   "item_type"
# t.float    "lat"                                                        
# t.float    "lng"                                                        
# t.string   "slug"
# t.string   "short_name"

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
			return find(:all, :order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		end

		if user.city_id > 0 
			find(:all, :select => "distinct markers.*", :conditions =>[ "markers.archive = false and (upper(markers.city) = upper(?) or markers.id = ?)", user.city.name, marker], 
			:order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		else
			# find(:all, :select => "distinct markers.*", :joins => "join groups on groups.marker_id = markers.id").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
			return find(:all, :order => "markers.name").collect {|p| [ "#{p.name} (#{p.city})", p.id ] }
		end
	end  

  def my_sports
    @my_sports = []
    self.sports.each { |sport| @my_sports << sport.id unless @my_sports.include?(sport.id) } 
    Sport.find(:all, :conditions => ["id in (?)", @my_sports], :order => "sports.name")
  end
end