class Tournament < ActiveRecord::Base

  # acts_as_solr :fields => [:name, :description, :time_zone], :include => [:sport, :marker] if use_solr?

  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/tournaments/:id/:style.:extension",
    :path => ":assets/tournaments/:id/:style.:extension",
    :default_url => "group_avatar.png"  

    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes

    # validations 
    validates_uniqueness_of   :name,    :case_sensitive => false

    validates_presence_of     :name
    validates_presence_of     :description
    validates_presence_of     :conditions
    validates_presence_of     :time_zone
    validates_presence_of     :sport_id
    validates_presence_of     :marker_id

    validates_length_of       :name,            :within => NAME_RANGE_LENGTH
    validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
    validates_length_of       :conditions,      :within => DESCRIPTION_RANGE_LENGTH

    validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 

    validates_presence_of         :fee_per_tour
    validates_numericality_of     :fee_per_tour
    
    validates_presence_of     :starts_at, :ends_at, :signup_at, :deadline_at
    
    validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
    validates_numericality_of :player_limit,    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

    # variables to access
    attr_accessible :name, :points_for_win, :points_for_draw, :points_for_lose, :fee_per_tour, :player_limit
    attr_accessible :time_zone, :sport_id, :marker_id, :description, :conditions, :photo
    attr_accessible :starts_at, :ends_at, :signup_at, :deadline_at

    # friendly url and removes id
    has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

    has_and_belongs_to_many :users,           :join_table => "tournaments_users",   :order => "name"

    has_many      :rounds
    
    has_many      :messages
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
    :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Tournament'"]

    belongs_to    :sport   
    belongs_to    :marker 

    has_one       :blog
    has_many      :fees

    before_create :format_description, :format_conditions
    before_update :format_description, :format_conditions
    after_create  :create_tournament_blog_details, :create_tournament_scorecard

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

    def avatar
      self.photo.url
    end

    def thumbnail
      self.photo.url
    end

    def icon
      self.photo.url
    end

    def has_round?
      self.rounds.count > 0
    end

    def use_goals?
      # sports related to goals
      return [1, 2, 3, 4, 5].include?(self.sport_id)
    end

    def available_users
      self.users.find(:all, :conditions => 'available = true', :order => 'users.name')      
    end

    def games_played
      games_played = 0
      self.meets.each {|schedule| games_played += 1 if schedule.played}
      return games_played
    end

    def create_tournament_details(user)
      user.has_role!(:manager, self)
      user.has_role!(:creator, self)
      user.has_role!(:member,  self)

      # Standing.create_user_scorecard(user, self)    
      TournamentsUsers.join_tour(user, self)
    end

    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def format_conditions
      self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
    end

    private

    def create_tournament_blog_details
      @blog = Blog.create_tournament_blog(self)
      # @entry = Entry.create_tournament_entry(self, @blog)
      # Comment.create_tournament_comment(self, @blog, @entry)
    end

    def create_tournament_scorecard   
      # Standing.create_tournament_scorecard(self)
    end
    
    def validate
      self.errors.add(:signup_at, I18n.t(:must_be_before_signup_at)) if self.signup_at >= self.deadline_at
      self.errors.add(:deadline_at, I18n.t(:must_be_before_deadline_at)) if self.deadline_at <= self.signup_at
      self.errors.add(:starts_at, I18n.t(:must_be_after_deadline_at)) if self.starts_at <= self.deadline_at
      self.errors.add(:starts_at, I18n.t(:must_be_before_starts_at)) if self.starts_at >= self.ends_at
      self.errors.add(:ends_at, I18n.t(:must_be_before_ends_at)) if self.ends_at <= self.starts_at
    end
  end


