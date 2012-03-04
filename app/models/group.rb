class Group < ActiveRecord::Base

	# extend FriendlyId
	
  # index do
  #   name
  #   description
  #   second_team
  # end

  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/s3.yml",
  :url => "/assets/groups/:id/:style.:extension",
  :path => ":assets/groups/:id/:style.:extension",
  :default_url => "group_avatar.png"  



  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
  validates_attachment_size         :photo, :less_than => 5.megabytes


  # validations 
  validates_uniqueness_of   :name,    :case_sensitive => false

  validates_presence_of     :name
  validates_presence_of     :second_team
  validates_presence_of     :description
  validates_presence_of     :conditions
  validates_presence_of     :time_zone
  validates_presence_of     :sport_id
  validates_presence_of     :marker_id

  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :second_team,     :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
  validates_length_of       :conditions,      :within => DESCRIPTION_RANGE_LENGTH

  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
  validates_format_of       :second_team,     :with => /^[A-z 0-9 _.-]*$/ 

  validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :player_limit,    :greater_than_or_equal_to => 1, :less_than_or_equal_to => DUNBAR_NUMBER

  # variables to access
  attr_accessible :name, :second_team, :gameday_at, :sport_id, :points_for_win, :points_for_draw, :points_for_lose, :player_limit, :automatic_petition
  attr_accessible :time_zone, :marker_id, :description, :conditions, :photo, :available, :looking, :enable_comments, :installation_id

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  # friendly_id :name, :use => :slugged, :approximate_ascii => true, 
  # :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  has_and_belongs_to_many :users,           :join_table => "groups_users", :conditions => "users.archive = false", :order => "name"

  has_many      :classifieds,       :conditions => "classifieds.archive = false"
  has_many      :schedules,         :conditions => "schedules.archive = false"
  has_many      :fees,              :conditions => "fees.archive = false"   
  has_many      :payments,          :conditions => "payments.archive = false"
  has_many      :scorecards,        :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"
 
  belongs_to    :sport   
  belongs_to    :marker 
  belongs_to    :installation

  has_one       :blog


  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Group'"]

  has_many :the_subscriptions,
  :through => :subscription_roles,
  :source => :roles_users

  has_many  :subscription_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'subscription' and roles.authorizable_type = 'Group'"]

  before_create :format_description, :format_conditions
  before_update :format_description, :format_conditions
  after_create  :create_group_blog_details, :create_group_marker, :create_group_scorecard

  acts_as_authorization_subject

  # method section
  def object_counter(objects)
    @counter = 0
    objects.each { |object|  @counter += 1 }
    return @counter
  end

  def all_the_managers
    ids = []
    self.the_managers.each {|user| ids << user.user_id }
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def all_subscribers
    ids = []
    self.users.each {|user| ids << user.user_id if user.is_subscriber_of?(self)}
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def all_non_subscribers
    ids = []
    self.users.each {|user| ids << user.user_id unless user.is_subscriber_of?(self)}
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def total_managers
    counter = 0
    self.all_the_managers.each {|user| counter += 1}
    return counter
  end

  def avatar
    self.photo.url
  end

  def mediam
    self.photo.url(:medium)
  end

  def thumbnail
    self.photo.url(:thumb)
  end

  def icon
    self.photo.url(:icon)
  end

  def name_to_second_team
    unless self.name.blank?
      self.second_team = "#{self.name} II"
      self.second_team.split(".").map {|n| n.capitalize }.join(" ")
    end
  end

  def name_to_description
    self.description = I18n.t(:description)
  end

  def default_conditions
    self.conditions = I18n.t(:default_group_conditions)
  end

  def sport_to_points_player_limit
    if self.sport
      self.points_for_win = self.sport.points_for_win
      self.points_for_draw = self.sport.points_for_draw
      self.points_for_lose = self.sport.points_for_lose
      self.player_limit = self.sport.player_limit    
    end
  end

  def has_schedule?
    self.schedules.count > 0
  end

  def is_futbol?
    # sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end

  def is_basket?
    # sports related to basket
    return [7].include?(self.sport_id)
  end

  def is_group_member_of?(item)
    self.has_role?('member', item)
  end
  
  def venue
    self.marker.venue
  end

  def self.latest_items(items)
    find(:all, :select => "id, name, photo_file_name, updated_at as created_at", :conditions => ["created_at >= ? and archive = false", LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end

  def self.latest_updates(items)
    find(:all, :select => "id, name, photo_file_name, updated_at as created_at", :conditions => ["updated_at >= ? and archive = false", LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end

  def self.looking_for_user(user)
    find(:all, 
    :conditions => ["id not in (?) and archive = false and looking = true and time_zone = ?", user.groups, user.time_zone],
    :order => "updated_at",
    :limit => LOOKING_USERS) 
  end

  def available_users
    self.users.find(:all, :conditions => 'available = true', :order => 'users.name')      
  end

  def games_played
    games_played = 0
    self.schedules.each {|schedule| games_played += 1 if schedule.played}
    return games_played
  end

  def create_group_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)

    Scorecard.create_user_scorecard(user, self)    
    GroupsUsers.join_team(user, self)
  end

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end

  private
  def create_group_marker
    GroupsMarkers.join_marker(self, self.marker)
  end

  def create_group_blog_details
    @blog = Blog.create_item_blog(self)
  end

  def create_group_scorecard   
    Scorecard.create_group_scorecard(self)
  end
end

