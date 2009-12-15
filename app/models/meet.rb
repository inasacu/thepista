class Meet < ActiveRecord::Base

  include ActivityLogger

  acts_as_solr :fields => [:concept, :description, :time_zone, :starts_at]  if use_solr? 

  has_friendly_id :concept, :use_slug => true, 
  :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  belongs_to  :round
  has_many    :clashes,  :conditions => "clashes.archive = false",    :order => "user_score DESC",      :dependent => :destroy
  has_many    :fees,                                                                                    :dependent => :destroy 
  has_one     :forum,                                                                                   :dependent => :destroy

  has_many    :home_roster,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id = 1 and clashes.meet_id = (select meets.round_id from meets where meet_id = clashes.meet_id limit 1)",
              :order =>       :name

  # has_many    :away_roster,
  #             :through => :clashes,
  #             :source => :convocado,
  #             :conditions =>  "clashes.type_id = 1 and clashes.invite_id = (select meets.round_id from meets where meet_id = clashes.meet_id limit 1)",
  #             :order =>       :name

  has_many    :convocados,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id = 1",
              :order =>       :name

  has_many    :last_minute,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id = 2",
              :order =>       :name

  has_many    :no_shows,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id in (3, 4)",
              :order =>       :name

  has_many    :no_jugado,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id in (4)",
              :order =>       :name

  has_many    :unavailable,
              :through => :clashes,
              :source => :convocado,
              :conditions =>  "clashes.type_id in (1,2,3,4)",
              :order =>       :name

  belongs_to  :sport
  belongs_to  :marker

  # validations  
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/ 

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH
  
  validates_presence_of         :player_limit,  :jornada
  validates_numericality_of     :player_limit,  :jornada
  
  validates_numericality_of     :jornada,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of     :player_limit,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  validates_presence_of         :starts_at, :ends_at, :reminder_at  

  # variables to access
  attr_accessible :concept, :description, :jornada, :starts_at, :ends_at, :reminder_at
  attr_accessible :time_zone, :tournament_id, :round_id, :sport_id, :marker_id, :player_limit, :public


  # after_update        :save_clashes
  before_create       :format_description
  before_update       :set_time_to_utc, :format_description

  after_create        :log_activity
  after_update        :log_activity_played

  def the_roster
    Clash.find(:all,    
    :select => "clashes.*, users.name as user_name, types.name as type_name, standings.id as standing_id, " +
    "standings.played as standing_played, standings.ranking, standings.points ",
    :joins => "left join users on users.id = clashes.user_id left join types on types.id = clashes.type_id left join standings on standings.user_id = clashes.user_id",
    :conditions => ["clashes.meet_id = ? and clashes.archive = false and clashes.type_id = 1  and standings.round_id = ? and users.available = true ", self.id, self.round_id],
    :order => "clashes.meet_id desc, users.name")
  end

  def the_last_minute
    Clash.find(:all,    
    :select => "clashes.*, users.name as user_name, types.name as type_name, standings.id as standing_id, " +
    "standings.played as standing_played, standings.ranking, standings.points ",
    :joins => "left join users on users.id = clashes.user_id left join types on types.id = clashes.type_id left join standings on standings.user_id = clashes.user_id",
    :conditions => ["clashes.meet_id = ?  and clashes.archive = false and clashes.type_id = 2 and standings.round_id = ? and users.available = true ", self.id, self.round_id],
    :order => "clashes.meet_id desc, users.name")
  end

  def the_no_show
    Clash.find(:all,    
    :select => "clashes.*, users.name as user_name, types.name as type_name, standings.id as standing_id, " +
    "standings.played as standing_played, standings.ranking, standings.points ",
    :joins => "left join users on users.id = clashes.user_id left join types on types.id = clashes.type_id left join standings on standings.user_id = clashes.user_id",
    :conditions => ["clashes.meet_id = ?  and clashes.archive = false and clashes.type_id in (3,4) and standings.round_id = ? and users.available = true ", self.id, self.round_id],
    :order => "clashes.meet_id desc, users.name")
  end

  def the_unavailable
    Clash.find(:all,    
    :select => "clashes.*, users.name as user_name, types.name as type_name, standings.id as standing_id, " +
    "standings.played as standing_played, standings.ranking, standings.points ",
    :joins => "left join users on users.id = clashes.user_id left join types on types.id = clashes.type_id left join standings on standings.user_id = clashes.user_id",
    :conditions => ["clashes.meet_id = ?  and clashes.archive = false and clashes.type_id in (1,2,3,4) and standings.round_id = ? and users.available = false ", self.id, self.round_id],
    :order => "clashes.meet_id desc, users.name")
  end

  def sport_name
    self.round.tournament.sport.name
  end
  
  def time_zone
    self.round.tournament.time_zone
  end

  def home_round
    self.round.name
  end
  
  def tournament
    self.round.tournament
  end
  
  def sport
    self.round.tournament.sport
  end

  def self.max(meet)
    find(:first, :conditions => ["round_id = ? and played = true", meet.round_id], :order => "starts_at desc")    
  end

  def self.previous(meet, option=false)
    if self.count(:conditions => ["id < ? and round_id = ?", meet.id, meet.round_id] ) > 0
      return find(:first, :select => "max(id) as id", :conditions => ["id < ? and round_id = ?", meet.id, meet.round_id]) 
    end
    return meet
  end 

  def self.next(meet, option=false)
    if self.count(:conditions => ["id > ? and round_id = ?", meet.id, meet.round_id]) > 0
      return find(:first, :select => "min(id) as id", :conditions => ["id > ? and round_id = ?", meet.id, meet.round_id])
    end
    return meet
  end

  def self.upcoming_meets(hide_time)
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

  # create forum, topic, post details for meet
  def create_meet_details(user, recipients, meet_update=false)
    unless meet_update
      @forum = Forum.create_meet_forum(self)
      @topic = Topic.create_forum_topic(@forum, user) 
      Post.create_topic_post(@forum, @topic, user, self.description)
    end

    recipients.each do |user|
      Clash.create_meet_clash(self, user)
      Standing.create_user_standing(user, self.round)
    end  
    Clash.update_clash_details(self)  
  end

  def create_join_user_meet_details
    Clash.create_meet_clash(self) 
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
    # add_activities(:item => self, :user => self.round.all_the_managers.first) 
  end

  def log_activity_played
    # add_activities(:item => self, :user => self.round.all_the_managers.first) if self.played?
  end

  def validate
    # self.errors.add(:starts_at, I18n.t(:must_be_after_deadline_at)) if self.starts_at < self.round.tournament.deadline_at
    # self.errors.add(:starts_at, I18n.t(:must_be_before_starts_at)) if self.starts_at >= self.ends_at
    # self.errors.add(:ends_at, I18n.t(:must_be_before_ends_at)) if self.ends_at <= self.starts_at
    # self.errors.add(:reminder_at, I18n.t(:must_be_after_deadline_at)) if self.reminder_at < self.round.tournament.signup_at
    # self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at > self.starts_at
  end

end
