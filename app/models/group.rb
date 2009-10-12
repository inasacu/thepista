class Group < ActiveRecord::Base

  acts_as_solr :fields => [:name, :second_team, :description, :time_zone], :include => [:sport, :marker] if use_solr?
  
  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/groups/:id/:style.:extension",
    :path => ":assets/groups/:id/:style.:extension",
    :default_url => "group_avatar.png"  

    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
    validates_attachment_size         :photo, :less_than => 5.megabytes
    

  # validations 
  validates_uniqueness_of   :name,          :message => I18n.t(:has_been_taken)
  validates_presence_of     :name,          :within => NAME_RANGE_LENGTH
  validates_presence_of     :second_team,   :within => NAME_RANGE_LENGTH
  validates_presence_of     :description,   :within => DESCRIPTION_RANGE_LENGTH
  validates_presence_of     :time_zone
  validates_presence_of     :sport_id
  validates_presence_of     :marker_id
  # validates_format_of       :name,          :with => /^.+ .+$/
  # validates_format_of       :name,          :with => /^[A-Z0-9_]$/i, :message =>"must contain only letters, numbers and underscores"

  # variables to access
  attr_accessible :name, :second_team, :gameday_at, :points_for_win, :points_for_draw, :points_for_lose
  attr_accessible :time_zone, :sport_id, :marker_id, :description, :conditions, :photo

  has_and_belongs_to_many :users,           :join_table => "groups_users",   :order => "name"

  has_many      :schedules
  has_many      :addresses  
  has_many      :accounts 
  has_many      :messages
  has_many      :accounts  
  has_many      :payments
  has_many      :scorecards, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"
  
  has_many      :archive_scorecards, 
                :through => :scorecards,
                :conditions => ["user_id > 0 and played > 0 and season_ends_at < ?", Time.zone.now], 
                :order => "points DESC, ranking"
                
  has_many      :fees   

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Group'"]

  belongs_to    :sport   
  belongs_to    :marker 

  has_one       :blog

  after_create  :create_group_blog_details, :create_group_marker, :create_group_scorecard

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
  
  def has_schedule?
    self.schedules.count > 0
  end
  
  def use_goals?
   	# sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end

  # def game_day
  #   self.schedules.find_by_sql(["select distinct dayname(starts_at) as name from schedules " +
  #                                "where group_id = #{self.id} or invite_id = #{self.id} " +
  #                                "group by dayname(starts_at) order by dayofweek(starts_at)"])
  # end

  def available_users
      self.users.find(:all, :conditions => 'available = true', :order => 'users.name')      
  end
  
  def games_played
    games_played = 0
    self.schedules.each {|schedule| games_played += 1 if schedule.played}

    # @match = Match.find(:first, :select => "count(*) as total", 
    # :conditions => ["schedule_id in (select id from schedules where group_id = ?) and type_id = 1", self.id],
    # :group => "user_id", :order => "count(*) desc")
    # 
    # games_played = @match.total
    return games_played
  end

  def create_group_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)

    Scorecard.create_user_scorecard(user, self)    
    GroupsUsers.join_team(user, self)
  end


private
  def create_group_marker
    GroupsMarkers.join_marker(self, self.marker)
  end

  def create_group_blog_details
    @blog = Blog.create_group_blog(self)
    @entry = Entry.create_group_entry(self, @blog)
    Comment.create_group_comment(self, @blog, @entry)
  end

  def create_group_scorecard   
    Scorecard.create_group_scorecard(self)
  end
end

