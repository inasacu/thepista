class Challenge < ActiveRecord::Base

  index do
    name
    description
  end
  
  # validations 
  validates_uniqueness_of       :name,            :case_sensitive => false

  validates_presence_of         :name
  validates_presence_of         :description
  validates_presence_of         :conditions
  validates_presence_of         :time_zone

  validates_length_of           :name,            :within => NAME_RANGE_LENGTH
  validates_length_of           :description,     :within => DESCRIPTION_RANGE_LENGTH
  validates_length_of           :conditions,      :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :fee_per_game
  validates_numericality_of     :fee_per_game

  validates_format_of           :name,            :with => /^[A-z 0-9 _.-]*$/ 

  validates_numericality_of     :player_limit,    :greater_than_or_equal_to => 1, :less_than_or_equal_to => DUNBAR_NUMBER

  # variables to access
  attr_accessible :name, :cup_id, :starts_at, :ends_at, :reminder_at, :fee_per_game, :time_zone, :description, :conditions, :player_limit, :archive, :automatic_petition
  
  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]
                   
  has_and_belongs_to_many :users,   :conditions => 'users.archive = false',   :order => 'name'

  belongs_to    :cup
  has_many      :casts
  has_many      :messages 
  has_many      :payments
  has_many      :fees
  has_many      :standings, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Challenge'"]

  before_create :format_description, :format_conditions
  before_update :format_description, :format_conditions

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

  def total_managers
    counter = 0
    self.all_the_managers.each {|user| counter += 1}
    return counter
  end

  def avatar
    self.cup.photo.url
  end

  def thumbnail
    self.cup.photo.url
  end

  def icon
    self.cup.photo.url
  end
  
  def has_cast?
    self.casts.count > 0
  end

  def is_futbol?
    # sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end

  def is_basket?
    # sports related to basket
    return [7].include?(self.sport_id)
  end
  
  def points_for_double
    self.cup.games.first.points_for_double
  end

  def create_challenge_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)

    ChallengesUsers.join_item(user, self)
    Blog.create_item_blog(self)
    Standing.delay.create_cup_challenge_standing(self)
    Cast.delay.create_challenge_cast(self) 
    Fee.delay.create_user_challenge_fees(self)
  end 
  
  def self.current_challenges(page = 1)
    self.paginate(:all, :conditions => ["cup_id in (select id from cups where archive = false)"], :order => 'name', :page => page, :per_page => CUPS_PER_PAGE)
  end 
  
  def self.latest_items(items)
    find(:all, :conditions => ["created_at >= ?", LAST_WEEK], :order => "id desc").each do |item| 
      items << item
    end
    return items
  end

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end

  private
  def validate
    self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
  end

end

