class Challenge < ActiveRecord::Base
 
    # validations 
    validates_uniqueness_of   :name,    :case_sensitive => false

    validates_presence_of     :name
    # validates_presence_of     :second_team
    validates_presence_of     :description
    validates_presence_of     :conditions
    validates_presence_of     :time_zone
    # validates_presence_of     :sport_id
    # validates_presence_of     :marker_id

    validates_length_of       :name,            :within => NAME_RANGE_LENGTH
    # validates_length_of       :second_team,     :within => NAME_RANGE_LENGTH
    validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
    validates_length_of       :conditions,      :within => DESCRIPTION_RANGE_LENGTH

    validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
    # validates_format_of       :second_team,     :with => /^[A-z 0-9 _.-]*$/ 

    # validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    # validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    # validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    validates_numericality_of :player_limit,    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    # variables to access
    attr_accessible :name, :player_limit
    attr_accessible :time_zone, :description, :conditions

    # friendly url and removes id  
    # has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

    has_and_belongs_to_many :users,           :join_table => "challenges_users",   :order => "name"

    belongs_to    :cup
    has_many      :casts
    has_many      :messages 
    has_many      :payments
    has_many      :fees
    has_many      :standings, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"

    has_many      :archive_standings, 
    :through => :standings,
    :conditions => ["user_id > 0 and played > 0 and season_ends_at < ?", Time.zone.now], 
    :order => "points DESC, ranking"
  

    has_many :the_managers,
    :through => :manager_roles,
    :source => :roles_users

    has_many  :manager_roles,
    :class_name => "Role", 
    :foreign_key => "authorizable_id", 
    :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Challenge'"]

    has_many :the_subscriptions,
    :through => :subscription_roles,
    :source => :roles_users

    has_many  :subscription_roles,
    :class_name => "Role", 
    :foreign_key => "authorizable_id", 
    :conditions => ["roles.name = 'subscription' and roles.authorizable_type = 'Challenge'"]

    # belongs_to    :sport   
    # belongs_to    :marker 

    # has_one       :blog
    

    before_create :format_description, :format_conditions
    before_update :format_description, :format_conditions
    after_create  :create_challenge_blog_details, :create_challenge_standing

    # # method section

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
      self.photo.url
    end

    def thumbnail
      self.photo.url
    end

    def icon
      self.photo.url
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

    def self.looking_for_user(user)
      find(:all, 
      :conditions => ["id not in (?) and archive = false and looking = true and time_zone = ?", user.challenges, user.time_zone],
      :order => "updated_at",
      :limit => LOOKING_USERS) 
    end

    def available_users
      self.users.find(:all, :conditions => 'available = true', :order => 'users.name')      
    end

    def games_played
      games_played = 0
      self.casts.each {|cast| games_played += 1 if cast.played}
      return games_played
    end

    def create_challenge_details(user)
      user.has_role!(:manager, self)
      user.has_role!(:creator, self)
      user.has_role!(:member,  self)

      # Standing.create_user_standing(user, self)    
      ChallengesUsers.join_team(user, self)
    end

    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def format_conditions
      self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
    end

    private

    def create_challenge_blog_details
      @blog = Blog.create_item_blog(self)
    end

    def create_challenge_standing   
      Standing.create_challenge_standing(self)
    end
  end

