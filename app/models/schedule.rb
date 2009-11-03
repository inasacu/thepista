class Schedule < ActiveRecord::Base
  
  include ActivityLogger
  
  acts_as_solr :fields => [:concept, :description, :time_zone, :starts_at]  if use_solr? 

  
  has_many  :matches,  :conditions => "matches.archive = false",    :dependent => :destroy
  has_many  :fees,                                                  :dependent => :destroy 
  has_one   :forum,                                                 :dependent => :destroy
  
  has_many :home_roster,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id = 1 and matches.group_id = (select schedules.group_id from schedules where schedule_id = matches.schedule_id limit 1)",
           :order =>       :name
  
  has_many :away_roster,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id = 1 and matches.invite_id = (select schedules.group_id from schedules where schedule_id = matches.schedule_id limit 1)",
           :order =>       :name
    
  has_many :convocados,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id = 1",
           :order =>       :name
  
  has_many :last_minute,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id = 2",
           :order =>       :name
         
  has_many :no_shows,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id in (3, 4)",
           :order =>       :name

   has_many :no_jugado,
            :through => :matches,
            :source => :convocado,
            :conditions =>  "matches.type_id in (4)",
            :order =>       :name
           
  has_many :unavailable,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id in (1,2,3,4)",
           :order =>       :name
  
  belongs_to :group
  belongs_to :sport
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"
   
  # validations  
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  
  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH
  
  validates_presence_of         :fee_per_game,  :fee_per_pista, :player_limit
  validates_numericality_of     :fee_per_game,  :fee_per_pista, :player_limit

  validates_presence_of         :starts_at,     :ends_at  
  # validates_presence_of         :time_zone
  # validates_presense_of         :sport_id, :marker_id, :group_id

  # variables to access
  attr_accessible :concept, :description, :season, :jornada, :starts_at, :ends_at, :reminder, :subscription_at, :non_subscription_at
  attr_accessible :fee_per_game, :fee_per_pista, :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :description, :season_ends_at
  
  
  # after_update        :save_matches
  before_create       :format_description
  before_update       :set_time_to_utc, :format_description
  
  after_create        :log_activity
  after_update        :log_activity_played

  def the_roster
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id desc, users.name")
  end
  
  def the_last_minute
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id desc, users.name")
  end
  
  def the_no_show
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id desc, users.name")
  end
  
  def the_unavailable
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.group_id = ? and users.available = false ", self.id, self.group_id],
      :order => "matches.group_id desc, users.name")
  end

  def last_season?(user)
    return false if self.season_ends_at.nil? and user.is_manager_of?(self.group)
    return (self.season_ends_at < Time.zone.now() and user.is_manager_of?(self.group))
  end
  
  def home_group
    self.group.name
  end
  
  def away_group
    self.group.second_team
  end
  
  def self.current_schedules(user, page = 1)
     self.paginate(:all, 
        :conditions => ["starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],
        :order => 'starts_at, group_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end

  def self.previous_schedules(user, page = 1)
     self.paginate(:all, 
     :conditions => ["starts_at < ? and (season_ends_at is null or season_ends_at > ?) and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, Time.zone.now, user.id],
     :order => 'starts_at desc, group_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end

  def self.archive_schedules(user, page = 1)
    self.paginate(:all, 
    :conditions => ["season_ends_at < ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],
    :order => 'starts_at, group_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end
  
  def self.max(schedule)
      find(:first, :conditions => ["group_id = ? and played = true", schedule.group_id], :order => "starts_at desc")    
  end
  
  def self.previous(schedule, option=false)
    if self.count(:conditions => ["id < ? and group_id = ?", schedule.id, schedule.group_id] ) > 0
      return find(:first, :select => "max(id) as id", :conditions => ["id < ? and group_id = ?", schedule.id, schedule.group_id]) 
    end
      return schedule
  end 
  
  def self.next(schedule, option=false)
    if self.count(:conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id]) > 0
      return find(:first, :select => "min(id) as id", :conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id])
    end
    return schedule
  end
        
  def self.upcoming_schedules(hide_time)
    with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :played => false}, :order => "starts_at"} do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
      end
    end
  end
  
  def game_played?
    played == true
  end

  def not_played?
    played == false
  end
  
  def create_schedule_details(user, update_schedule=false)
    unless update_schedule
      # create forum, topic, post details for schedule
      @forum = Forum.create_schedule_forum(self)
      @topic = Topic.create_schedule_topic(@forum, user)
    else  
      @forum = Forum.find(self.forum)
      @topic = Topic.find(@forum.topics.first)
    end
    Post.create_schedule_post(@forum, @topic, user, self.description)

    Match.create_schedule_match(self) 

    Fee.create_group_fees(self)    
    Fee.create_user_fees(self)
  end
  
  def create_join_user_schedule_details
    Match.create_schedule_match(self) 
    Fee.create_user_fees(self)
  end
  
  private
  
  def format_description
    self.description.gsub!(/\r?\n/, "<br>")
  end
  
  def set_time_to_utc
    # self.starts_at = self.starts_at.utc
    # self.ends_at = self.ends_at.utc
  end
  
  def log_activity
    add_activities(:item => self, :user => self.group.all_the_managers.first) 
  end
  
  def log_activity_played
    add_activities(:item => self, :user => self.group.all_the_managers.first) if self.played?
  end
end
