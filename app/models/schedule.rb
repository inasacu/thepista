class Schedule < ActiveRecord::Base

  
  acts_as_solr :fields => [:concept, :description, :time_zone, :starts_at]  if use_solr? #, :include => [:sport, :marker] if use_solr?
  
  # include ActivityLogger
  # 
  # ## variables
  # # ONE_WEEK_FROM_TODAY = Time.now - 1.day..Time.now + 7.days
  # # NAME_RANGE_LENGTH = 3..255
  # # DESCRIPTION_RANGE_LENGTH = 3..2000
  # 
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
  # 
  # 
  # validates_presence_of       :concept,          :within => NAME_RANGE_LENGTH
  # validates_presence_of       :starts_at
  # validates_presence_of       :time_zone
  # validates_presence_of       :sport_id
  # validates_presence_of       :marker_id
  # validates_presence_of       :group_id
  # validates_numericality_of   :fee_per_game
  # validates_numericality_of   :fee_per_pista
  # 
  # validates_associated        :matches
  # 
  # after_update        :save_matches
  # after_create        :log_activity
  # after_update        :log_activity_played

  # def the_roster
  #   Match.find(:all,    
  #     :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
  #                "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
  #     :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
  #     :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
  #     :order => "matches.group_id, users.name")
  # end
  # 
  # def the_last_minute
  #   Match.find(:all,    
  #     :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
  #                "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
  #     :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
  #     :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (4, 5) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
  #     :order => "matches.group_id, users.name")
  # end
  # 
  # def the_no_show
  #   Match.find(:all,    
  #     :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
  #                "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
  #     :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
  #     :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (2, 3) and scorecards.group_id = ? and users.available = true ", self.id, self.group_id],
  #     :order => "matches.group_id, users.name")
  # end
  # 
  # def the_unavailable
  #   Match.find(:all,    
  #     :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
  #                "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points ",
  #     :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
  #     :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4,5) and scorecards.group_id = ? and users.available = false ", self.id, self.group_id],
  #     :order => "matches.group_id, users.name")
  # end
  # 
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
  # 
  # def home_group
  #   self.group.name
  # end
  # 
  # def away_group
  #   (self.group_id == self.invite_id or self.invite_id == 0) ? self.group.second_team : self.invite_group.name
  # end
  # 
  # def self.max(schedule)
  #     find(:first, :conditions => ["group_id = ? and played = true", schedule.group_id], :order => "starts_at desc")    
  # end
  # 
  # def self.previous(schedule, option=false)
  #   if self.count(:conditions => ["id < ? and group_id = ?", schedule.id, schedule.group_id] ) > 0
  #     return find(:first, :select => "max(id) as id", :conditions => ["id < ? and group_id = ?", schedule.id, schedule.group_id]) 
  #   end
  #     return schedule
  # end 
  # 
  # def self.next(schedule, option=false)
  #   if self.count(:conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id]) > 0
  #     return find(:first, :select => "min(id) as id", :conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id])
  #   end
  #   return schedule
  # end
  #       
  # def self.current_schedules(hide_time)
  #   with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :played => false}, :order => "starts_at"} do
  #     if hide_time.nil?
  #       find(:all)
  #     else
  #       find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
  #     end
  #   end
  # end
  # 


  # 
  # def game_played?
  #   played == true
  # end
  # 
  # def is_invite?
  #   (!invite_id.nil? and invite_id > 0 and group_id != invite_id)
  # end
  # 
  # def not_played?
  #   played == false
  # end
  # 
  # def has_schedule?(group)
  #   schedule = get_schedule(group)
  #   schedule ? true : false
  # end
  # 
  # def create_schedule_details
  #   create_matches
  #   create_forum_topic_post
  #   create_user_fees
  #   create_group_fees
  # end
  # 
  # def create_join_user_schedule_details
  #   create_matches
  #   create_user_fees
  # end

  # def create_forum_topic_post    
  #   manager_id = 0
  # 
  #   self.group.users.each do |user|
  #     if user.is_manager_of?(self.group) and manager = 0        
  #       manager_id = user.id 
  #     end
  #   end
  #   
  #   @forum = Forum.find_by_schedule_id(self.id)
  #   if @forum.nil?
  #     Forum.create(:schedule_id => self.id, :name => self.concept, :description => self.description) 
  #   else
  #     @forum.update_attributes(:name => self.concept, :description => self.description)
  #   end 
  #   
  #   @forum = Forum.find_by_schedule_id(self.id)
  #   @topic = Topic.find_by_forum_id(@forum.id)
  #   if @topic.nil?
  #     Topic.create(:forum_id => @forum.id, :user_id => manager_id, :name => self.concept)
  #   else
  #     @topic.update_attribute("name", self.concept)
  #   end
  #       
  #   @topic = Topic.find_by_forum_id(@forum.id)
  #   @post = Post.find_by_topic_id(@topic.id)
  #   if @post.nil?
  #     Post.create(:topic_id => @forum.topics.first.id, :user_id => manager_id, :body => self.description)
  #   else
  #     @post.update_attribute("body", self.description)
  #   end  
  #   
  # end
  # 
  # def update_forum_topic_post(message, user)
  #    @forum = Forum.find_by_schedule_id(self.id)
  #    if @forum.nil?
  #      create_forum_topic_post and return
  #    end
  #    
  #   @topic = @forum.topics.first
  #   
  #   @post = Post.new(:body => message.body, :topic_id => @topic.id, :user_id => user.id)
  #   @post.save!
  # end
  # 
  # def create_matches
  #   # if the invite_id is filled then
  #   # this is a match between different teams
  #   # create record in match table for teammates in invite team
  # 
  #   @lastSchedule = Schedule.find(:first,
  #     :conditions => ["id = (select max(id) from schedules where id != (select max(id) from schedules where group_id = ?)) ", self.group_id])
  # 
  #   if (!self.invite_id.nil? and self.invite_id > 0 and self.group_id != self.invite_id)
  #     Group.find(self.invite_id).users.each do |user|
  # 
  #       type_id = 1      
  #       type_id = 3 if self.played
  #         
  #       unless @lastSchedule.nil?
  #         @match = Match.find_by_schedule_id_and_user_id(@lastSchedule, user)
  #         type_id = @match.type_id if !@match.nil?
  #       end
  # 
  #       Match.create(:name => self.concept, :schedule_id => self.id,
  #         :group_id => self.invite_id, :user_id => user.id,
  #         :available => user.available, :type_id => type_id, :played => self.played) if Match.exists?(self, user)
  #     end
  #   end
  # 
  #   # create a record in the match table for teammates in group team
  #   self.group.users.each do |user|
  #     type_id = 1      
  #     type_id = 3 if self.played
  #     
  #     unless @lastSchedule.nil?
  #       @match = Match.find_by_schedule_id_and_user_id(@lastSchedule, user)
  #       type_id = @match.type_id if !@match.nil?
  #     end
  # 
  #     Match.create(:name => self.concept, :schedule_id => self.id,
  #       :group_id => self.group_id, :user_id => user.id,
  #       :available => user.available, :type_id => type_id, :played => self.played) if Match.exists?(self, user)
  #   end
  # end
  # 
  # def create_matches_for_join_user(user)
  #   the_match = self.matches.find(:first)
  #   type_id = 3
  #   
  #   Match.create(:name => the_match.name, :schedule_id => the_match.schedule_id, :group_id => the_match.group_id, 
  #                :invite_id => the_match.invite_id, :user_id => user.id, :available => user.available, 
  #                :type_id => type_id, :played => the_match.played, :group_score => the_match.group_score, 
  #                :invite_score => the_match.invite_score, :one_x_two => the_match.one_x_two, 
  #                :user_x_two => the_match.user_x_two, :description => the_match.description) if Match.exists?(self, user)
  # end
  # 
  # def create_user_fees
  #   if (!self.invite_id.nil? and self.invite_id > 0 and self.group_id != self.invite_id)
  #     Group.find(self.invite_id).users.each do |user|
  #       
  #       actual_fee = self.fee_per_game
  #       actual_fee = 0 if user.available == 'is_not_available' or self.played
  #       
  #       Fee.create(:concept => self.concept,
  #         :schedule_id => self.id,
  #         :user_id => user.id,
  #         :group_id => self.invite_id,
  #         :actual_fee => actual_fee) if Fee.exists?(self, user)
  #     end
  #   end
  # 
  #   self.group.users.each do |user|
  #     actual_fee = self.fee_per_game
  #     actual_fee = 0 if user.available == 'is_not_available' or self.played
  # 
  #     Fee.create(:concept => self.concept,
  #       :schedule_id => self.id,
  #       :user_id => user.id,
  #       :group_id => self.group_id,
  #       :actual_fee => actual_fee) if Fee.exists?(self, user)
  #   end
  # end
  # 
  # def create_group_fees
  #   if (!self.invite_id.nil? and self.invite_id > 0 and self.group_id != self.invite_id)
  #     Fee.create(:concept => self.concept,
  #       :schedule_id => self.id,
  #       :group_id => self.invite_id,
  #       :actual_fee => self.fee_per_pista)
  #   end
  # 
  #   Fee.create(:concept => self.concept,
  #     :schedule_id => self.id,
  #     :group_id => self.group_id,
  #     :actual_fee => self.fee_per_pista)
  # end
  # 
  # private
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
