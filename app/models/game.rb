# TABLE "games"
# t.string   "name"
# t.datetime "starts_at"
# t.datetime "s_at"
# t.datetime "reminder_at"
# t.datetime "deadline_at"
# t.integer  "cup_id"
# t.integer  "home_id"
# t.integer  "away_id"
# t.integer  "winner_id"
# t.integer  "next_game_id"
# t.integer  "home_ranking"
# t.string   "home_stage_name"
# t.integer  "away_ranking"
# t.string   "away_stage_name"
# t.integer  "home_score"
# t.integer  "away_score"
# t.integer  "jornada"                                  
# t.integer  "round"                                    
# t.boolean  "played"                                   
# t.string   "type_name"                  
# t.integer  "points_for_single"                        
# t.integer  "points_for_double"                        
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "points_for_draw"                          
# t.integer  "points_for_goal_difference"               
# t.integer  "points_for_goal_total"                    
# t.integer  "points_for_winner"                        
# t.boolean  "archive"                                  
# t.string   "slug"

class Game < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged

	acts_as_tree :foreign_key => :next_game_id

	# alias_method :next_game, :parent

	alias_method :previous_games, :children
	alias_method :game_for_winner, :parent

	belongs_to  :cup

	belongs_to  :winner,     :class_name => 'Escuadra',  :foreign_key => 'winner_id' 
	belongs_to  :home,       :class_name => 'Escuadra',  :foreign_key => 'home_id' 
	belongs_to  :away,       :class_name => 'Escuadra',  :foreign_key => 'away_id'

	belongs_to  :next_game,  :class_name => 'Game',  :foreign_key => 'next_game_id'

	belongs_to  :home_escuadra,     :class_name => "Escuadra",   :foreign_key => "home_id"
	belongs_to  :invite_escuadra,   :class_name => "Escuadra",   :foreign_key => "invite_id"

	has_many    :casts

	# validations   
	validates_presence_of         :name
	validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
	validates_format_of           :name,                         :with => /^[A-z 0-9 _.-]*$/
	validates_numericality_of     :jornada,                         :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 999

	validates_numericality_of     :home_ranking,                    :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8,    :allow_nil => true
	validates_numericality_of     :away_ranking,                    :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8,    :allow_nil => true  
	validates_numericality_of     :home_score,                      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 300,  :allow_nil => true
	validates_numericality_of     :away_score,                      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 300,  :allow_nil => true

	validates_numericality_of     :points_for_single,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
	validates_numericality_of     :points_for_double,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
	validates_numericality_of     :points_for_draw,                 :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
	validates_numericality_of     :points_for_goal_difference,      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
	validates_numericality_of     :points_for_goal_total,           :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
	validates_numericality_of     :points_for_winner,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true

	validates_presence_of         :starts_at, :ends_at#, :reminder_at 

	# variables to access
	attr_accessible :name, :starts_at, :ends_at, :reminder_at, :deadline_at
	attr_accessible :points_for_single, :points_for_double, :points_for_draw, :points_for_goal_difference, :points_for_goal_total, :points_for_winner
	attr_accessible :cup_id, :home_id, :away_id, :winner_id, :next_game_id, :jornada, :round, :type_name
	attr_accessible :home_score, :away_score, :played, :home_ranking, :away_ranking, :home_stage_name, :away_stage_name, :slug
	attr_accessible	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time

	before_update :set_game_winner
	after_update  :calculate_standing
	after_create 	:create_challenges_cast

	attr_accessor 	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time
	before_update   :get_starts_at, :get_ends_at

	# add some callbacks, after_initialize :get_starts_at # convert db format to accessors
	before_create	:get_starts_at, :get_ends_at
	before_validation :get_starts_at, :get_ends_at, :set_starts_at, :set_ends_at 

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
	def self.group_stage_games(cup, page = 1)
		self.where("cup_id = ? and type_name = 'GroupStage'", cup).page(page).order('jornada')
	end

	def self.group_round_games(cup, page = 1)
		self.where("cup_id = ? and (type_name != 'GroupStage' or type_name is null)", cup).page(page).order('jornada')
	end

	def self.upcoming_games(hide_time)
		with_scope(:find => where(:starts_at => YESTERDAY_TO_TODAY, :played => false).order("starts_at")) do
			if hide_time.nil?
				self.all()
			else
				self.where("starts_at >= ?", hide_time)
			end
		end
	end

	def self.latest_items(items)
		cup_id = 0
		find(:all, :conditions => ["(created_at >= ?) or (updated_at >= ? and home_score is not null and away_score is not null)", LAST_24_HOURS, LAST_24_HOURS], :order => "cup_id desc").each do |item| 
			items << item if cup_id != item.cup_id
			cup_id = item.cup_id
		end
		return items
	end

	def self.final_game(cup)
		# find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?)", cup])
		find(:first, :conditions => ["cup_id = ? and type_name = 'FinalGame'", cup])
	end

	def self.last_game_escuadra_played(escuadra)
		find(:first, :select => "starts_at", :conditions => ["id = (select max(id) from games where played = true and escuadra_id = ?)", escuadra])
	end

	def self.last_cup_game(cup)
		find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?)", cup])
	end

	def game_played?
		played == true
	end

	def not_played?
		played == false
	end

	def sport_name
		self.cup.sport.name
	end

	def all_group_stage_played(cup)
		if Game.count(:conditions => ["cup_id = ? and played = false and type_name = 'GroupStage'", cup]) > 0      
			return false
		end
		return true
	end

	def is_cup_game_played(cup)
		if Game.count(:conditions => ["cup_id = ? and played = true", cup]) > 0      
			return false
		end
		return true
	end

	def self.find_all_games(standing)
		find(:all, :conditions => ["cup_id = ? and (home_id = ? or away_id = ?) and home_score is not null and away_score is not null and type_name = 'GroupStage'", standing.cup_id, standing.item_id, standing.item_id], :order => "id")
	end

	def first_players_previous_game
		self.children[0]
	end

	def winner
		return nil if game_for_winner.nil?
		game_for_winner.first_players_previous_game == self ? game_for_winner.home : game_for_winner.away
	end

	def winner_id= game_id
		return nil if game_for_winner.nil?
		if game_for_winner.first_players_previous_game == self 
			game_for_winner.home_id = game_id 
		else
			game_for_winner.away_id = game_id
		end
		game_for_winner.save
	end

	# return true if the round home away conbination is nil
	def self.cup_home_away_exist?(cup, home, away)
		find_by_cup_id_and_home_id_and_away_id(cup, home, away).nil?
	end

	def self.game_type
		return [[I18n.t(:type_groupstage), 'GroupStage'],  [I18n.t(:type_firstgame), 'FirstGame'], 
		[I18n.t(:type_subsequentgame), 'SubsequentGame'], [I18n.t(:type_thirdplacegame), 'ThirdPlaceGame'], 
		[I18n.t(:type_finalgame), 'FinalGame']]
	end

	private
	def calculate_standing
		if self.cup.official
			Game.update_cast_details(self.cup) 
			Game.delay.set_final_stage(self.cup) if self.all_group_stage_played(self.cup)

			Standing.delay.cup_challenges_user_standing(self.cup)
			Standing.delay.update_cup_challenge_item_ranking(self.cup)
		end	
		Standing.create_cup_escuadra_standing(self.cup)
		Standing.delay.calculate_cup_standing(self.cup)
	end

	def self.update_cast_details(cup)
		@cast = nil
		cup.challenges.each do |challenge|       
			Cast.delay.update_cast_details(challenge)
			@cast = challenge.casts.first if @cast == ''
		end
		Cast.delay.calculate_standing(@cast) unless (@cast == nil)
	end

	def self.set_final_stage(cup)
		@first_games = Game.where("cup_id = ? and type_name = 'FirstGame' and (home_id is null or away_id is null)", cup).order("id")

		@first_games.each do |first|
			standing = Standing.find(:first, :conditions => ["cup_id = ? and item_type = 'Escuadra' and group_stage_name = ? and ranking = ?", cup.id, first.home_stage_name, first.home_ranking])
			first.home_id = standing.item_id

			standing = Standing.find(:first, :conditions => ["cup_id = ? and item_type = 'Escuadra' and group_stage_name = ? and ranking = ?", cup.id, first.away_stage_name, first.away_ranking])

			first.away_id = standing.item_id
			first.save!
		end
	end

	def create_challenges_cast
		if self.cup.official
			self.cup.challenges.each do |challenge|
				Cast.delay.create_challenge_cast(challenge) 
				Fee.delay.create_user_challenge_fees(challenge) if DISPLAY_FREMIUM_SERVICES
			end
		end
	end

	def set_game_winner
		self.played = false
		self.winner_id = nil

		unless self.home_score.nil? or self.away_score.nil?
			if self.home_score.to_i > self.away_score.to_i
				self.winner_id = self.home_id
			end  
			if self.home_score.to_i < self.away_score.to_i
				self.winner_id = self.away_id
			end
			self.played = true
		end       

	end

	def validate
		# self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
		# self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
		# self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
		# self.errors.add(:deadline_at, I18n.t(:must_be_before_starts_at)) if self.deadline_at < self.starts_at
		self.errors.add(:home_id, I18n.t(:must_be_different)) if (self.home_id == self.away_id and !self.home_id.nil? and !self.away.nil?) 
	end

end