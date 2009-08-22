class Schedule < ActiveRecord::Base

  
  acts_as_solr :fields => [:concept, :description, :time_zone, :starts_at]  if use_solr? 

  
  has_many :matches,  :conditions => "matches.archive = false",   :dependent => :destroy
  has_many :fees,                                             :dependent => :destroy
  
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
           :conditions =>  "matches.type_id in (4,5)",
           :order =>       :name
         
  has_many :no_shows,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id in (2,3)",
           :order =>       :name
           
  has_many :unavailable,
           :through => :matches,
           :source => :convocado,
           :conditions =>  "matches.type_id in (1,2,3,4,5)",
           :order =>       :name
  
  has_one    :forum 
  
  belongs_to :group
  belongs_to :sport
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"
   
   
   validates_presence_of       :concept,          :within => NAME_RANGE_LENGTH
   validates_presence_of       :description,      :within => DESCRIPTION_RANGE_LENGTH
   validates_presence_of       :starts_at
   validates_presence_of       :time_zone
   validates_presence_of       :sport_id
   validates_presence_of       :marker_id
   validates_presence_of       :group_id
   validates_numericality_of   :fee_per_game
   validates_numericality_of   :fee_per_pista
   
  # validates_associated        :matches
  
  # variables to access
  attr_accessible :concept, :season, :jornada, :starts_at, :ends_at, :reminder_at, :subscription_at, :non_subscription_at
  attr_accessible :fee_per_game, :fee_per_pista, :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :description
  
  
  # after_update        :save_matches
  # after_create        :log_activity
  # after_update        :log_activity_played

  def the_roster
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id, users.name")
  end
  
  def the_last_minute
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (4, 5) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id, users.name")
  end
  
  def the_no_show
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (2, 3) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
      :order => "matches.group_id, users.name")
  end
  
  def the_unavailable
    Match.find(:all,    
      :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
      :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
      :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4,5) and scorecards.group_id = ? and users.available = false ", self.id, self.group_id],
      :order => "matches.group_id, users.name")
  end
  
  # def new_match_attributes=(match_attributes)
  #   match_attributes.each do |attributes|
  #     matches.build(attributes)
  #   end
  # end
  # 
  # def existing_match_attributes=(match_attributes)
  #   matches.reject(&:new_record?).each do |match|
  #     attributes = match_attributes[match.id.to_s]
  #     if attributes
  #       match.attributes = attributes
  #     else
  #       matches.delete(match)
  #     end
  #   end
  # end
  # 
  # def save_matches
  #   matches.each do |match|
  #     match.save(false)
  #   end
  # end 
  # 
  # def same_team?
  #   (self.group_id == self.invite_id or self.invite_id == 0)
  # end
  # 
  # def group_visit
  #   (self.group_id == self.invite_id or self.invite_id == 0) ? self.group : self.invite_group
  # end
  
  def home_group
    self.group.name
  end
  
  # def away_group
  #   (self.group_id == self.invite_id or self.invite_id == 0) ? self.group.second_team : self.invite_group.name
  # end
  
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
        
  def self.current_schedules(hide_time)
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
  
  # def is_invite?
  #   (!invite_id.nil? and invite_id > 0 and group_id != invite_id)
  # end
  
  def not_played?
    played == false
  end
  
  # def has_schedule?(group)
  #   schedule = get_schedule(group)
  #   schedule ? true : false
  # end
  
  def create_schedule_details(user)
    # create forum, topic, post details for schedule
    @forum = Forum.create_schedule_forum(self)
    @topic = Topic.create_schedule_topic(@forum, user)
    Post.create_schedule_post(@forum, @topic, user)
    
    create_schedule_match
    
    Fee.create_group_fees(self)    
    Fee.create_user_fees(self)
  end
  
  def create_join_user_schedule_details
    create_schedule_match
    Fee.create_user_fees(self)
  end

  
  # create a record in the match table for teammates in group team
  def create_schedule_match
    @last_schedule = Schedule.find(:first,
    :conditions => ["id = (select max(id) from schedules where id != (select max(id) from schedules where group_id = ?)) ", self.group_id])

    Match.create_schedule_match(self, @last_schedule)    
  end
  
  # def create_schedule_match_for_join_user(user)
  #   the_match = self.matches.find(:first)
  #   type_id = 3
  #   
  #   Match.create(:name => the_match.name, :schedule_id => the_match.schedule_id, :group_id => the_match.group_id, 
  #                :invite_id => the_match.invite_id, :user_id => user.id, :available => user.available, 
  #                :type_id => type_id, :played => the_match.played, :group_score => the_match.group_score, 
  #                :invite_score => the_match.invite_score, :one_x_two => the_match.one_x_two, 
  #                :user_x_two => the_match.user_x_two, :description => the_match.description) if Match.exists?(self, user)
  # end
  
  
  private
 
  
  # def get_schedule(group)
  #   Schedule.find( :first, :conditions => [ 'group_id = ? and played = false', group.id ])
  # end
  # 
  # def log_activity
  #   add_activities(:item => self, :user => self.group.all_the_managers.first) 
  # end
  # 
  # def log_activity_played
  #   add_activities(:item => self, :user => self.group.all_the_managers.first) if self.played?
  # end
end
