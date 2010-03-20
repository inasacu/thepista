class Schedule < ActiveRecord::Base

  include ActivityLogger

  # tagging
  acts_as_taggable_on :tags

  ajaxful_rateable :stars => 5, :dimensions => [:performance]

  acts_as_solr :fields => [:concept, :time_zone, :starts_at]  if use_solr? 

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
  # belongs_to :sport
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"

  # validations  
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/ 

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :fee_per_game,  :fee_per_pista, :player_limit,  :jornada
  validates_numericality_of     :fee_per_game,  :fee_per_pista, :player_limit,  :jornada

  validates_numericality_of     :jornada,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of     :player_limit,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  validates_presence_of         :starts_at,     :ends_at  

  # variables to access
  attr_accessible :concept, :description, :season, :jornada, :starts_at, :ends_at, :reminder_at, :reminder
  attr_accessible :fee_per_game, :fee_per_pista, :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :season_ends_at

  # friendly url and removes id
  has_friendly_id :concept, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  # after_update        :save_matches
  before_create       :format_description
  before_update       :set_time_to_utc, :format_description

  after_create        :log_activity
  after_update        :log_activity_played

  def the_roster_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ? and users.available = true ", self.id, self.group_id])
  end  

  def the_last_minute_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.group_id = ? and users.available = true ", self.id, self.group_id])
  end

  def the_no_show_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id])
  end

  def the_unavailable_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.group_id = ? and users.available = false ", self.id, self.group_id])
  end


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

  def sport
    self.group.sport
  end

  def last_season?(user)
    return false if self.season_ends_at.nil? and user.is_manager_of?(self.group)
    return (self.season_ends_at < Time.zone.now() and user.is_manager_of?(self.group))
  end

  def sport
    self.group.sport
  end

  def home_group
    self.group.name
  end

  def away_group
    self.group.second_team
  end

  def home_score
    # self.matches.first.group_score
    return Match.find_by_schedule_id(self, :order => 'group_score ASC').group_score
  end

  def away_score
    # self.matches.first.invite_score
    return Match.find_by_schedule_id(self, :order => 'invite_score ASC').invite_score
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

  def self.last_schedule_played(user)
    find(:first, :select => "starts_at", :conditions => ["id = (select max(schedule_id) from matches where user_id = ? and type_id = 1  and played = true)", user.id])
  end

  def self.last_schedule_group_played(group)
    find(:first, :select => "starts_at", :conditions => ["id = (select max(id) from schedules where played = true and group_id = ?)", group])
  end

  def game_played?
    played == true
  end

  def not_played?
    played == false
  end

  # create forum, topic, post details for schedule
  def create_schedule_details(user, schedule_update=false)
    unless schedule_update
      @forum = Forum.create_schedule_forum(self)
      # @topic = Topic.create_forum_topic(@forum, user) 
      # Post.create_topic_post(@forum, @topic, user, self.description)
    end
    Match.create_schedule_match(self) 
    Fee.create_group_fees(self)    
    Fee.create_user_fees(self)
  end

  def create_join_user_schedule_details
    Match.create_schedule_match(self) 
    Fee.create_user_fees(self)
  end

  def self.send_reminders
    schedules = Schedule.find(:all, :conditions => ["played = false and send_reminder_at is null and reminder = true and reminder_at >= ? and reminder_at <= ?", LAST_24_HOURS, NEXT_24_HOURS])
    schedules.each do |schedule|
      total_schedules = Schedule.count(:conditions => ["group_id = ?", schedule.group])
      one_third = total_schedules.to_f / 5
      manager_id = RolesUsers.find_team_manager(schedule.group).user_id

      schedule.group.users.each do |user|
        scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user, schedule.group])

        # send email to user and request to have a email sent
        if scorecard.played.to_i >= one_third.round and user.message_notification?   

          message = Message.new
          message.subject = "#{I18n.t(:reminder_at)}:  #{schedule.concept}"
          message.body = "#{I18n.t(:reminder_at_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
          message.item = schedule
          message.sender_id = manager_id
          message.recipient_id = user.id
          message.sender_read_at = Time.zone.now
          message.recipient_read_at = Time.zone.now
          message.sender_deleted_at = Time.zone.now
          message.recipient_deleted_at = Time.zone.now        
          message.save!

        end
      end

      schedule.send_reminder_at = Time.zone.now
      schedule.save!

    end
  end

  def self.send_results
    schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ? and send_result_at is null", LAST_24_HOURS, TWO_DAYS_AFTER])
    schedules.each do |schedule|

      match = Match.find(:first, :conditions => ["type_id = 1 and schedule_id = ? and (group_score is null or invite_score is null)", schedule])
      manager_id = RolesUsers.find_team_manager(schedule.group).user_id
      manager = User.find(manager_id)

      # send email to manager to update match result
      if !match.nil?  and manager.message_notification?   
        message = Message.new
        message.subject = "#{I18n.t(:update_match)}:  #{schedule.concept}"
        message.body = "#{I18n.t(:update_match_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
        message.item = match
        message.sender_id = manager_id
        message.recipient_id = manager_id
        message.sender_read_at = Time.zone.now
        message.recipient_read_at = Time.zone.now
        message.sender_deleted_at = Time.zone.now
        message.recipient_deleted_at = Time.zone.now        
        message.save!
      end  

      schedule.send_result_at = Time.zone.now
      schedule.save!   
    end
  end

  # after the event send for users to comment and the scorecard if updated...
  def self.send_after_comment_scorecards
    schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ?", LAST_24_HOURS, NEXT_24_HOURS])
    schedules.each do |schedule|

      scorecard = schedule.group.scorecards.first
      manager_id = RolesUsers.find_team_manager(schedule.group).user_id

      schedule.the_roster.each do |match|
        message = Message.new
        message.subject = "#{I18n.t(:reminder_wall_message)}:  #{schedule.concept}"
        message.body = "#{I18n.t(:reminder_after_game_message)}  #{schedule.concept}  #{I18n.t(:reminder_at_salute)}"
        message.item = schedule
        message.sender_id = manager_id
        message.recipient_id = match.user_id
        message.sender_read_at = Time.zone.now
        message.recipient_read_at = Time.zone.now
        message.sender_deleted_at = Time.zone.now
        message.recipient_deleted_at = Time.zone.now        
        message.save! 

      end

      # once game has been played then the scorecard will be automatically sent
      if schedule.played?
        schedule.group.users.each do |user|
          message = Message.new
          message.subject = "#{I18n.t(:scorecard_latest)}:  #{schedule.group.name}"
          message.body = "#{I18n.t(:scorecard_latest)}  #{schedule.group.name}  #{I18n.t(:reminder_at_salute)}"
          message.item = scorecard
          message.sender_id = manager_id
          message.recipient_id = user.id
          message.sender_read_at = Time.zone.now
          message.recipient_read_at = Time.zone.now
          message.sender_deleted_at = Time.zone.now
          message.recipient_deleted_at = Time.zone.now        
          message.save!
        end
      end

    end
  end

  private

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
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

  def validate
    self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
  end

end
