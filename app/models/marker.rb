class Marker < ActiveRecord::Base

  acts_as_mappable     :default_units => :kms

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
    find(:all, :conditions => "latitude is not null and longitude is not null")
  end

  def self.marker_name
    find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
  end  

  def my_sports
    @my_sports = []
    self.sports.each { |sport| @my_sports << sport.id unless @my_sports.include?(sport.id) } 
    Sport.find(:all, :conditions => ["id in (?)", @my_sports], :order => "name")
  end
end