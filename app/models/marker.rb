class Marker < ActiveRecord::Base
  
  acts_as_solr :fields => [:name] if use_solr?
  
  has_many   :groups
  has_many   :sports, :through => :groups
  
  def self.marker_name
    find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
  end  
  
  def my_sports
    @my_sports = []
    self.sports.each { |sport| @my_sports << sport.id unless @my_sports.include?(sport.id) } 
    Sport.find(:all, :conditions => ["id in (?)", @my_sports], :order => "name")
  end
end