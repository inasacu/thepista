# TABLE "schedules"
# t.string   "name"
# t.string   "season"
# t.integer  "jornada"
# t.datetime "starts_at"
# t.datetime "s_at"
# t.datetime "subscription_at"
# t.datetime "non_subscription_at"
# t.float    "fee_per_game"        
# t.float    "fee_per_pista"       
# t.integer  "remind_before"       
# t.integer  "repeat_every"        
# t.string   "time_zone"           
# t.integer  "group_id"
# t.integer  "sport_id"
# t.integer  "marker_id"
# t.integer  "player_limit"        
# t.boolean  "played"              
# t.boolean  "public"              
# t.boolean  "archive"             
# t.datetime "created_at"
# t.datetime "updated_at"
# t.boolean  "reminder"            
# t.datetime "reminder_at"
# t.datetime "s_reminder_at"
# t.datetime "s_result_at"
# t.datetime "s_comment_at"
# t.string   "slug"

class Schedule < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged

  has_many  :matches,  :conditions => "matches.archive = false", :order => "matches.group_score"
  has_many  :fees

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
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"

  # validations  
  # validates_presence_of         :name
  # validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
  # validates_format_of           :name,                         :with => /^[A-z 0-9 _.-]*$/ 
  # 
  # validates_presence_of         :fee_per_game,  :fee_per_pista, :player_limit,  :jornada
  # validates_numericality_of     :fee_per_game,  :fee_per_pista, :player_limit,  :jornada
  # 
  # validates_numericality_of     :jornada,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  # validates_numericality_of     :player_limit,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  # 
  # validates_presence_of         :starts_at,     :ends_at  

  # variables to access	
  attr_accessible :name, :season, :jornada, :starts_at, :ends_at, :reminder_at, :reminder
  attr_accessible :fee_per_game, :fee_per_pista, :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :archive, :schedule_and_name, :slug

  before_update       :set_time_to_utc 
  
  # method section
	def concept
			self.name
	end
		
  def schedule_and_name
    "#{group.name} #{name}"
  end

  def the_roster_sort(sort="")
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0

    the_sort = "matches.group_id DESC, users.name"
    the_sort = "#{sort}, #{the_sort}" if (sort != " ASC" and sort != " DESC" and !sort.blank? and !sort.empty?) 
     Match.find(:all, :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
                                 "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, 
                                 (100 * scorecards.played / #{played_games}) as coeficient_played",
                :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
                :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ?", self.id, self.group_id],
                :order => the_sort)
  end
  
  def self.match_participation(group, users, schedules)
    find(:all, :select => "distinct schedules.*",  
               :joins => "left join matches on matches.schedule_id  = schedules.id",
               :conditions => ["user_id in (?) and type_id = 1 and schedule_id in (?)", users, group.schedules]).each do |schedule|
      schedules << schedule
    end
  end
  
  def the_roster_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ?", self.id, self.group_id])
  end  

  def the_last_minute_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.group_id = ?", self.id, self.group_id])
  end

  def the_no_show_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.group_id = ?", self.id, self.group_id])
  end

  def the_unavailable_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.group_id = ?", self.id, self.group_id])
  end

  def the_roster
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0
    
    Match.find(:all,    
    :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
    "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, (100 * scorecards.played / #{played_games}) as coeficient_played",
    :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1  and scorecards.group_id = ?", self.id, self.group_id],
    :order => "matches.group_id desc, users.name")
  end

  def the_last_minute
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0
    
    Match.find(:all,    
    :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
    "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, (100 * scorecards.played / #{played_games}) as coeficient_played",
    :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.group_id = ?", self.id, self.group_id],
    :order => "matches.group_id desc, users.name")
  end

  def the_no_show
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0
    
    Match.find(:all,    
    :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
    "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, (100 * scorecards.played / #{played_games}) as coeficient_played",
    :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.group_id = ?", self.id, self.group_id],
    :order => "matches.group_id desc, users.name")
  end

  def the_unavailable
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0
    
    Match.find(:all,    
    :select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
    "scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, (100 * scorecards.played / #{played_games}) as coeficient_played",
    :joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.group_id = ?", self.id, self.group_id],
    :order => "matches.group_id desc, users.name")
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

	def installation
		self.group.installation.nil? ? (return self.group.marker) : (return self.group.installation)
	end

  def home_score
    return Match.find_score(self).group_score
  end

  def away_score
    return Match.find_score(self).invite_score
  end
  
  def self.group_current_schedules(group, page = 1)
    self.where("schedules.archive = false and starts_at >= ? and group_id = ?", Time.zone.now, group).page(page).order('starts_at')
  end

  def self.group_previous_schedules(group, page = 1)
    self.where("schedules.archive = false and starts_at < ? and group_id = ?", Time.zone.now, group).page(page).order('starts_at DESC')
  end
  
  def self.my_current_schedules(user)
    self.find(:all, :conditions => ["schedules.archive = false and starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],:order => 'starts_at, group_id', :limit => 1)
  end

  def self.current_schedules(user, page = 1)
    self.where("schedules.archive = false and starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id).page(page).order('starts_at, group_id')
  end

  def self.previous_schedules(user, page = 1)
    self.where("schedules.archive = false and starts_at < ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id).page(page).order('starts_at desc, group_id')
  end
  
  def self.latest_items(items)
    find(:all, :conditions => ["schedules.created_at >= ? and archive = false", LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end
  
  def self.latest_matches(items)
    find(:all, :select => "distinct schedules.id, schedules.name, schedules.group_id, schedules.played, schedules.updated_at as created_at", 
         :conditions => ["schedules.archive = false and schedules.played = true and schedules.updated_at >= ?", YESTERDAY],
         :order => "created_at desc", :limit => NUMBER_RECENT_MATCH_NOTES).each do |item| 
      items << item
    end
    return items
  end
  
  def self.weekly_reservations(marker, installation, starts_at, ends_at)
    find(:all, :joins => "JOIN groups on groups.id = schedules.group_id",
               :conditions => ["groups.marker_id = ?  and groups.installation_id = ? and schedules.played = false and schedules.archive = false and
                                schedules.starts_at >= ? and schedules.ends_at < ?", marker, installation, starts_at, ends_at], 
               :order => 'starts_at')
  end
  

	def self.get_schedule_first_to_last_month (first_day, last_day, installation)
		find(:all, :joins => "JOIN groups on groups.id = schedules.group_id",
				:conditions => ["schedules.archive = false and schedules.starts_at >= ? and schedules.ends_at <= ? and 
											  groups.archive = false and groups.installation_id = ?", first_day, last_day, installation], :order => 'starts_at')
	end
				
				
  def self.find_all_played(user, page = 1)
    self.where("matches.user_id = ? and matches.type_id = 1 and matches.archive = false", user).joins("left join matches on matches.schedule_id = schedules.id").page(params[:page]).order('schedules.starts_at desc')
  end

  def self.archive_schedules(user, page = 1)
    self.where("group_id in (select group_id from groups_users where user_id = ?)", user.id).page(params[:page]).order('starts_at, group_id')
  end

  def self.schedule_number(schedule)
    schedule_number = count(:conditions => ["group_id = ? and played = true and archive = false and starts_at < 
                            (select starts_at from schedules where group_id = ? and schedules.id = ?)", schedule.group, schedule.group, schedule])
    schedule_number += 1 
    return schedule_number
  end
    
  def self.max(schedule)
    find(:first, :conditions => ["group_id = ? and played = true", schedule.group_id], :order => "starts_at desc")    
  end

  def self.previous(schedule, option=false)
    if self.count(:conditions => ["id < ? and group_id = ?", schedule.id, schedule.group_id] ) > 0
      return find(:first, :select => "id", :conditions => ["group_id = ? and starts_at < ?", schedule.group_id, schedule.starts_at], :order => "starts_at desc")
    end
    return schedule
  end 

  def self.next(schedule, option=false)
    if self.count(:conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id]) > 0
      return find(:first, :select => "id", :conditions => ["group_id = ? and starts_at > ?", schedule.group_id, schedule.starts_at], :order => "starts_at")
    end
    return schedule
  end

	def self.upcoming_schedules(hide_time)
		with_scope(:find => where(:starts_at => ONE_WEEK_FROM_TODAY, :played => false).order("starts_at")) do
			if hide_time.nil?
				self.all()
			else
				self.where("starts_at >= ?", hide_time)
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

  # create fmatch details for schedule
	def create_schedule_details
		Match.create_schedule_match(self) 
		if DISPLAY_FREMIUM_SERVICES  
			Fee.create_group_fees(self) 
			Fee.create_user_fees(self) 
		end
	end

  def create_join_user_schedule_details
    Match.create_schedule_match(self) 
    Fee.create_user_fees(self) if DISPLAY_FREMIUM_SERVICES
  end
  
  def update_profile_from_user
    self.matches.each do |match|
      match.technical = match.user.technical.to_i
      match.physical = match.user.physical.to_i
      match.save!
    end
  end

  def self.send_reminders
    schedules = Schedule.find(:all, 
                  :conditions => ["played = false and send_reminder_at is null and reminder = true and reminder_at >= ? and reminder_at <= ?", PAST_THREE_DAYS, Time.zone.now])
    
		schedules.each do |schedule|
			manager_id = RolesUsers.find_item_manager(schedule.group).user_id
			schedule.group.users.each do |user|
				if user.message_notification? 
					create_notification_email(schedule, schedule, manager_id, user.id, true)
				end
			end
			schedule.send_reminder_at = Time.zone.now
			schedule.save!
		end

  end

  def self.send_results
    schedules = Schedule.find(:all, :conditions => ["starts_at >= ? and starts_at <= ? and send_result_at is null", PAST_THREE_DAYS, Time.zone.now])
    schedules.each do |schedule|

      match = Match.find(:first, :conditions => ["type_id = 1 and schedule_id = ? and (group_score is null or invite_score is null)", schedule])
      manager_id = RolesUsers.find_item_manager(schedule.group).user_id
      manager = User.find(manager_id)

      # send email to manager to update match result
      if !match.nil? and manager.message_notification?           
        create_notification_email(match, schedule, manager_id, manager_id)
      end  

      schedule.send_result_at = Time.zone.now
      schedule.save!   
    end
  end

  # after the event send for users to comment and the scorecard if updated...
  def self.send_after_comments
    schedules = Schedule.find(:all, :conditions => ["send_comment_at is null and starts_at >= ? and starts_at <= ?", PAST_THREE_DAYS, Time.zone.now])
    schedules.each do |schedule|

      # scorecard = schedule.group.scorecards.first
      manager_id = RolesUsers.find_item_manager(schedule.group).user_id

      schedule.the_roster.each do |match|        
        create_notification_email(schedule, schedule, manager_id, match.user_id)
      end

      schedule.send_comment_at = Time.zone.now
      schedule.save!

    end
  end
  
  # after the event send for users see the scorecard if updated...
  def self.send_after_scorecards
    schedules = Schedule.find(:all, :conditions => ["played = true and updated_at >= ? and updated_at <= ?", LAST_24_HOURS, Time.zone.now])
    schedules.each do |schedule|

      scorecard = schedule.group.scorecards.first
      manager_id = RolesUsers.find_item_manager(schedule.group).user_id

      # once game has been played then the scorecard will be automatically sent
      if schedule.played?
        schedule.group.users.each do |user|
          create_notification_email(scorecard, schedule, manager_id, user.id)
        end
      end

    end
  end
  
  def self.create_notification_email(item, schedule, manager_id, user_id, reminder=false)

    the_subject = ""
    the_body = ""

    case item.class.to_s
    when "Schedule"
      
      if reminder
        the_subject = "#{I18n.t(:reminder_at)}:  #{schedule.name}"
        the_body = "#{I18n.t(:reminder_at_message)}  #{schedule.name}  #{I18n.t(:reminder_at_salute)}"
      else
        the_subject = "#{I18n.t(:reminder_wall_message)}:  #{schedule.name}"
        the_body = "#{I18n.t(:reminder_after_game_message)}  #{schedule.name}  #{I18n.t(:reminder_at_salute)}"
      end
      
    when "Scorecard"
      the_subject = "#{I18n.t(:scorecard_latest)}:  #{schedule.group.name}"
      the_body = "#{I18n.t(:scorecard_latest)}  #{schedule.group.name}  #{I18n.t(:reminder_at_salute)}"
    when "Match"
      the_subject = "#{I18n.t(:update_match)}:  #{schedule.name}"
      the_body = "#{I18n.t(:update_match_message)}  #{schedule.name}  #{I18n.t(:reminder_at_salute)}"
    end

    message = Message.new
    message.subject = the_subject
    message.body = the_body
    message.item = item
    message.sender_id = manager_id
    message.recipient_id = user_id
    message.sender_read_at = Time.zone.now
    message.recipient_read_at = Time.zone.now
    message.sender_deleted_at = Time.zone.now
    message.recipient_deleted_at = Time.zone.now        
    message.save!

  end

  private

  def set_time_to_utc
    # self.starts_at = self.starts_at.utc
    # self.ends_at = self.ends_at.utc
  end

  def validate
    if self.archive == false
      self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at 
      self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at 
    end
  end

end
