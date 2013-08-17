# == Schema Information
#
# Table name: schedules
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  season              :string(255)
#  jornada             :integer
#  starts_at           :datetime
#  ends_at             :datetime
#  subscription_at     :datetime
#  non_subscription_at :datetime
#  fee_per_game        :float            default(0.0)
#  fee_per_pista       :float            default(0.0)
#  remind_before       :integer          default(2)
#  repeat_every        :integer          default(7)
#  time_zone           :string(255)      default("UTC")
#  group_id            :integer
#  sport_id            :integer
#  marker_id           :integer
#  player_limit        :integer          default(0)
#  played              :boolean          default(FALSE)
#  public              :boolean          default(TRUE)
#  archive             :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  reminder            :boolean          default(TRUE)
#  reminder_at         :datetime
#  send_reminder_at    :datetime
#  send_result_at      :datetime
#  send_comment_at     :datetime
#  slug                :string(255)
#  send_created_at     :datetime
#

class Schedule < ActiveRecord::Base

	extend FriendlyId
	friendly_id :name_slug, 					use: :slugged

	def name_slug
		"#{self.group.name} #{name}".gsub(" ", "_")
	end

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

  belongs_to :group, :include => [ :sport, :installation ]
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"

  # validations  
  validates_presence_of         :name
  validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :name,                         :with => /^[A-z 0-9 _.-]*$/ 
  
  validates_presence_of         :fee_per_game,  :fee_per_pista, :player_limit,  :jornada
  validates_numericality_of     :fee_per_game,  :fee_per_pista, :player_limit,  :jornada
  validates_numericality_of     :player_limit,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
	
  # validates_numericality_of     :jornada,       	:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  # validates_presence_of         :starts_at,     	:ends_at  
  # validates_format_of 					:starts_at_time, 	:with => /\d{1,2}:\d{2}/
  # validates_format_of 					:ends_at_time, 		:with => /\d{1,2}:\d{2}/

  # variables to access	
  attr_accessible :name, :season, :jornada, :starts_at, :ends_at, :reminder_at, :reminder
  attr_accessible :fee_per_game, :fee_per_pista, :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :archive, :schedule_and_name, :slug, :block_token
	attr_accessible	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time

	attr_accessor 	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time
	attr_accessor 	:available, :item_id, :item_type, :group_name, :match_status_at, :match_schedule_id
	attr_accessor   :match_group_id, :match_user_id, :match_type_id, :match_type_name, :match_played, :timeframe
	attr_accessor		:ismock
	
  before_update   :get_starts_at, :get_ends_at
  
  # add some callbacks, after_initialize :get_starts_at # convert db format to accessors
	before_create			:get_starts_at, :get_ends_at
  before_validation :get_starts_at, :get_ends_at, :set_starts_at, :set_ends_at 
	
	validates_time		:ends_at,			:after => :starts_at
	
	def get_starts_at
		self.starts_at ||= Time.now  
		self.starts_at_date ||= self.starts_at.to_date.to_s(:db) 
		self.starts_at_time ||= "#{'%02d' % self.starts_at.hour}:#{'%02d' % self.starts_at.min}" 
	end

	def set_starts_at
		self.starts_at = "#{self.starts_at_date} #{self.starts_at_time}:00" 
	end
	
	def get_ends_at
		self.ends_at ||= Time.now  
		self.ends_at_date ||= self.ends_at.to_date.to_s(:db) 
		self.ends_at_time ||= "#{'%02d' % self.ends_at.hour}:#{'%02d' % self.ends_at.min}" 
	end

	def set_ends_at
		self.ends_at = "#{self.ends_at_date} #{self.ends_at_time}:00" 
	end

  # method section
	def concept
			self.name
	end
		
  def schedule_and_name
    "#{group.name} #{name}"
  end

	def self.first_group_schedule(group)
		find(:first, :conditions => ["schedules.group_id = ?", group.id], :order => "schedules.starts_at DESC")  
	end

  def the_roster_sort(sort="")
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0

    the_sort = "matches.group_id DESC, users.name"
    the_sort = "#{sort}, #{the_sort}" if (sort != " ASC" and sort != " DESC" and !sort.blank? and !sort.empty?) 

		Match.select("matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, 
									scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, 
									(100 * scorecards.played / #{played_games}) as coeficient_played").joins("join users on users.id = matches.user_id 
									join types on types.id = matches.type_id 
									join scorecards on scorecards.user_id = matches.user_id").where("matches.schedule_id = ? and 
									matches.archive = false and matches.type_id = 1 and scorecards.archive = false and 
									scorecards.group_id = ?", self.id, self.group_id).order(the_sort)
  end

	def the_last_minute_infringe
		the_match = Match.find(:all, :select => "distinct matches.user_id",
							 						 :joins => "join schedules on schedules.id = matches.schedule_id
																			join groups on groups.id = schedules.group_id",
							 						 :conditions => ["schedules.group_id = ? and matches.type_id > 2 and
																						 schedules.starts_at > ? and date_part('days', schedules.starts_at - matches.status_at) = 0 and
															 							 matches.created_at < schedules.starts_at", self.group_id, NINE_MONTHS_AGO],
													 :group => "matches.user_id", :having => ["count(*) > ?", REPUTATION_LAST_MINUTE_INFRINGE])
			the_infringe = []
			the_match.each {|match| the_infringe << match.user_id}
			return the_infringe
	end
	
	def the_roster_infringe
		the_match = Match.find(:all, :select => "distinct matches.user_id",
							 						 :joins => "join schedules on schedules.id = matches.schedule_id
																			join groups on groups.id = schedules.group_id",
							 							:conditions => ["schedules.group_id = ? and schedules.starts_at > ? and
																	   				 matches.type_id = 4 and 
																						 matches.status_at > schedules.starts_at	and 
															 							 matches.created_at < schedules.starts_at", self.group_id, THREE_MONTHS_AGO])
			the_infringe = []
			the_match.each {|match| the_infringe << match.user_id}
			return the_infringe
	end
	
	def the_roster_reputation(group)
			the_match = Match.find_by_sql(["select matches.user_id, count(*) from (
										select matches.schedule_id, schedules.player_limit, count(*), (count(*) * 100/ schedules.player_limit)  as player_percent
										from schedules, matches
										where schedules.group_id = ?
										and schedules.id = matches.schedule_id
										and matches.type_id = 1
										and schedules.played = true
										group by matches.schedule_id, schedules.player_limit
										having count(*) < player_limit ) match_limit, matches
										where player_percent < ?
										and match_limit.schedule_id = matches.schedule_id
										and matches.type_id = 1 
										group by matches.user_id
										having count(*) > ?", group, REPUTATION_PERCENT, REPUTATION_GAME_MINIMUM])
									
		the_reputation = []
		the_match.each {|match| the_reputation << match.user_id}
		return the_reputation
	end
	
	def the_roster_last_played
			the_match = Match.find(:all, :select => "distinct matches.user_id",
							 							:conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1", Schedule.previous(self)])
			last_played = []
			the_match.each {|match| last_played << match.user_id}
			return last_played
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
    :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1 and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id])
  end  

  def the_last_minute_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id])
  end

  def the_no_show_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id])
  end

  def the_unavailable_count
    Match.count(:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id])
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
    :conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1 and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id],
    :order => "matches.group_id desc, users.name")
  end

	def the_roster_wo_default_user
		the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", self.group], :order => "starts_at desc")
		played_games = 0
		the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0

		Match.find(:all,    
		:select => "matches.*, users.name as user_name, types.name as type_name, scorecards.id as scorecard_id, " +
		"scorecards.played as scorecard_played, scorecards.ranking, scorecards.points, (100 * scorecards.played / #{played_games}) as coeficient_played",
		:joins => "left join users on users.id = matches.user_id left join types on types.id = matches.type_id left join scorecards on scorecards.user_id = matches.user_id",
		:conditions => ["matches.schedule_id = ? and matches.archive = false and matches.type_id = 1 and scorecards.archive = false and scorecards.group_id = ? and matches.user_id not in (?)", 
					self.id, self.group_id, DEFAULT_GROUP_USERS],	:order => "matches.group_id desc, users.name")
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
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id = 2 and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id],
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
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (3,4) and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id],
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
    :conditions => ["matches.schedule_id = ?  and matches.archive = false and matches.type_id in (1,2,3,4) and scorecards.archive = false and scorecards.group_id = ?", self.id, self.group_id],
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

	# def self.has_schedule?(group)
	# 		!find(:first, :conditions => ["group_id = ? and played = true", group]).nil?
	# end
  
  def self.group_current_schedules(group, page = 1)
    self.where("schedules.archive = false and starts_at >= ? and group_id = ?", Time.zone.now, group).page(page).order('starts_at')
  end

  def self.group_previous_schedules(group, page = 1)
    self.where("schedules.archive = false and starts_at < ? and group_id = ?", Time.zone.now, group).page(page).order('starts_at DESC')
  end
  
  def self.my_current_schedules(user)
    self.find(:all, :conditions => ["schedules.archive = false and starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],:order => 'starts_at, group_id', :limit => 1)
  end

	def self.other_current_schedules(user)
		self.find(:all, :conditions => ["schedules.archive = false and starts_at >= ? and group_id not in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],:order => 'starts_at, group_id', :limit => 1)
	end

  def self.current_schedules(user, page = 1)
    self.select("schedules.*").joins("JOIN groups on groups.id = schedules.group_id").where("schedules.archive = false and starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", 
		Time.zone.now, user.id).page(page).order('groups.name, schedules.starts_at').includes(:group)
  end

  def self.previous_schedules(user, page = 1)
    self.select("schedules.*").joins("JOIN groups on groups.id = schedules.group_id").where("schedules.archive = false and starts_at < ? and group_id in (select group_id from groups_users where user_id = ?)", 
		Time.zone.now, user.id).page(page).order('groups.name, schedules.starts_at DESC').includes(:group)
  end
  
  def self.latest_items(items)
    find(:all, :joins => "JOIN groups on groups.id = schedules.group_id",
							 :conditions => ["schedules.created_at >= ? and schedules.archive = false and groups.item_type != 'Branch'", LAST_THREE_DAYS]).each do |item| 
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
	
	def self.get_schedule_item_first_to_last_month (first_day, last_day, item)
		find(:all, :joins => "JOIN groups on groups.id = schedules.group_id",
				:conditions => ["schedules.archive = false and schedules.starts_at >= ? and schedules.ends_at <= ? and 
												groups.archive = false and groups.item_id = ? and groups.item_type = ?", first_day, last_day, item.id, item.class.to_s.chomp], :order => 'starts_at')
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
			return find(:first, :conditions => ["group_id = ? and starts_at < ?", schedule.group_id, schedule.starts_at], :order => "starts_at desc")
		end
		return schedule
	end 

	def self.next(schedule, option=false)
		if self.count(:conditions => ["id > ? and group_id = ?", schedule.id, schedule.group_id]) > 0
			return find(:first, :conditions => ["group_id = ? and starts_at > ?", schedule.group_id, schedule.starts_at], :order => "starts_at")
		end
		return schedule
	end

	def self.upcoming_schedules(hide_time)
		with_scope(:find => where(:starts_at => ONE_WEEK_FROM_TODAY, :played => false).order("starts_at").includes(:group)) do
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

  def create_schedule_roles(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)
  end

  # create match details for schedule
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

	def last_minute_reminder
		manager_id = RolesUsers.find_item_manager(self.group).user_id
		self.group.users.each do |user|
			if user.has_last_minute_notification?
				Schedule.delay.create_notification_email(self, self, manager_id, user.id, true)
			end
		end
	end

  def self.send_reminders
    schedules = Schedule.find(:all, 
                  :conditions => ["played = false and send_reminder_at is null and reminder = true and reminder_at >= ? and reminder_at <= ?", PAST_THREE_DAYS, Time.zone.now])
    
		schedules.each do |schedule|
			manager_id = RolesUsers.find_item_manager(schedule.group).user_id
			schedule.group.users.each do |user|
				if user.teammate_notification? 
					create_notification_email(schedule, schedule, manager_id, user.id, true)
				end
			end
			schedule.send_reminder_at = Time.zone.now
			schedule.save!
		end

  end

	def self.send_created
		schedules = Schedule.find(:all, 
		:conditions => ["played = false and send_created_at is null and created_at >= ? and created_at <= ?", YESTERDAY, Time.zone.now])

		schedules.each do |schedule|
			manager_id = RolesUsers.find_item_manager(schedule.group).user_id
			schedule.group.users.each do |user|
				if user.teammate_notification? 
					create_notification_email(schedule, schedule, manager_id, user.id, true)
				end
			end
			schedule.send_created_at = Time.zone.now
			schedule.save!
		end

	end

  def self.send_results
    schedules = Schedule.find(:all, :conditions => ["played = true and starts_at >= ? and starts_at <= ? and send_result_at is null", YESTERDAY, Time.zone.now], )
    schedules.each do |schedule|

      match = Match.find(:first, :conditions => ["type_id = 1 and schedule_id = ? and (group_score is null or invite_score is null)", schedule])
      manager_id = RolesUsers.find_item_manager(schedule.group).user_id
      manager = User.find(manager_id)

      # send email to manager to update match result
      if !match.nil? and manager.teammate_notification?           
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
    schedules = Schedule.find(:all, :conditions => ["played = true and starts_at >= ? and starts_at <= ? and send_result_at is null", YESTERDAY, Time.zone.now])
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

		@user = User.find(manager_id)
		I18n.locale = @user.language unless @user.language.blank?


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

end
