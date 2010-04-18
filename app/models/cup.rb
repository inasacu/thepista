class Cup < ActiveRecord::Base

  acts_as_solr :fields => [:name, :time_zone] if use_solr? #, :include => [:sport, :marker] 
                  
  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/cups/:id/:style.:extension",
    :path => ":assets/cups/:id/:style.:extension",
    :default_url => "group_avatar.png"  

    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes

  # validations 
  validates_uniqueness_of   :name,    :case_sensitive => false
  
  validates_presence_of     :name
  validates_presence_of     :description
  validates_presence_of     :time_zone
  validates_presence_of     :sport_id
  
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
      
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
    
  validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  # variables to access
  attr_accessible :name, :points_for_win, :points_for_draw, :points_for_lose
  attr_accessible :time_zone, :sport_id, :description, :photo
  attr_accessible :starts_at, :ends_at, :deadline_at
    
  # friendly url and removes id  
  # has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  has_and_belongs_to_many :escuadras,     :join_table => "cups_escuadras",   :order => "name"
  has_many                :games
  has_many                :standings,     :order => "points DESC, ranking"

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_squads

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Cup'"]

  belongs_to    :sport   

  before_create :format_description
  before_update :format_description

  # # method section    
  def object_counter(objects)
    @counter = 0
    objects.each { |object|  @counter += 1 }
    return @counter
  end

  def the_escuadras
    return self.escuadras.collect {|p| [ p.name, p.id ] }
    
    # find(:all, :order => "name").collect {|p| [ p.name, p.id ] }
  end
  
  # def all_the_managers
  #   ids = []
  #   self.the_managers.each {|user| ids << user.user_id }
  #   the_squads = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  # end

  def avatar
    self.photo.url
  end

  def thumbnail
    self.photo.url
  end

  def icon
    self.photo.url
  end
  
  def has_game?
    self.games.count > 0
  end
  
  def is_futbol?
   	# sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end
  
  def is_basket?
   	# sports related to basket
    return [7].include?(self.sport_id)
  end
  
  def games_played
    the_played = 0
    self.games.each {|game| the_played += 1 if game.played}
    return the_played
  end

  def create_cup_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)
  end
  
  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end
  
  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end
private


def validate
  self.errors.add(:deadline_at, I18n.t(:must_be_before_starts_at)) if self.deadline_at >= self.starts_at
  self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
  self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
end
end

