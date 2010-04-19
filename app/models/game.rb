class Game < ActiveRecord::Base

  acts_as_tree :foreign_key => :next_game_id

  alias_method :next_game, :parent


  belongs_to :cup

  belongs_to :winner,     :class_name => 'Escuadra',  :foreign_key => 'winner_id' 
  belongs_to :home,       :class_name => 'Escuadra',  :foreign_key => 'home_id' 
  belongs_to :away,       :class_name => 'Escuadra',  :foreign_key => 'away_id'
  
  belongs_to :next_game,  :class_name => 'Game',  :foreign_key => 'next_game_id'

  before_update :set_game_winner
  
  belongs_to :home_escuadra,     :class_name => "Escuadra",   :foreign_key => "home_id"
  belongs_to :invite_escuadra,   :class_name => "Escuadra",   :foreign_key => "invite_id"

  # validations  
  # validates_numericality_of     :home_score,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 300
  # validates_numericality_of     :away_score,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 300

  validates_presence_of         :starts_at, :ends_at, :reminder_at, :home_id, :away_id

  # variables to access
  attr_accessible :starts_at, :ends_at, :reminder_at, :cup_id, :home_id, :away_id, :winner_id, :next_game_id

  # friendly url and removes id
  # has_friendly_id :concept, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]


  # method section  
  def self.current_games(user, page = 1)
    self.paginate(:all, 
    :conditions => ["starts_at >= ? and escuadra_id in (select escuadra_id from escuadras_users where user_id = ?)", Time.zone.now, user.id],
    :order => 'starts_at, escuadra_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end

  def self.previous_games(user, page = 1)
    self.paginate(:all, 
    :conditions => ["starts_at < ? and (season_ends_at is null or season_ends_at > ?) and escuadra_id in (select escuadra_id from escuadras_users where user_id = ?)", Time.zone.now, Time.zone.now, user.id],
    :order => 'starts_at desc, escuadra_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end

  def self.archive_games(user, page = 1)
    self.paginate(:all, 
    :conditions => ["season_ends_at < ? and escuadra_id in (select escuadra_id from escuadras_users where user_id = ?)", Time.zone.now, user.id],
    :order => 'starts_at, escuadra_id', :page => page, :per_page => SCHEDULES_PER_PAGE)
  end

  def self.max(game)
    find(:first, :conditions => ["escuadra_id = ? and played = true", game.escuadra_id], :order => "starts_at desc")    
  end

  # def self.previous(game, option=false)
  #   if self.count(:conditions => ["id < ? and escuadra_id = ?", game.id, game.escuadra_id] ) > 0
  #     return find(:first, :select => "max(id) as id", :conditions => ["id < ? and escuadra_id = ?", game.id, game.escuadra_id]) 
  #   end
  #   return game
  # end 
  # 
  # def self.next(game, option=false)
  #   if self.count(:conditions => ["id > ? and escuadra_id = ?", game.id, game.escuadra_id]) > 0
  #     return find(:first, :select => "min(id) as id", :conditions => ["id > ? and escuadra_id = ?", game.id, game.escuadra_id])
  #   end
  #   return game
  # end

  def self.upcoming_games(hide_time)
    with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :played => false}, :order => "starts_at"} do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
      end
    end
  end

  def self.last_game_played(user)
    find(:first, :select => "starts_at", :conditions => ["id = (select max(game_id) from matches where user_id = ? and type_id = 1  and played = true)", user.id])
  end

  def self.last_game_escuadra_played(escuadra)
    find(:first, :select => "starts_at", :conditions => ["id = (select max(id) from games where played = true and escuadra_id = ?)", escuadra])
  end

  def game_played?
    played == true
  end

  def not_played?
    played == false
  end

  private

  def validate
    self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
    self.errors.add(:home_id, I18n.t(:must_be_different)) if self.home_id == self.away_id
  end


  # 
  # # method section
  # def set_game_winner
  # 
  #   unless self.home_score.nil? or self.away_score.nil?
  #     if self.home_score > self.away_score
  #       self.winner_id = self.home_id
  #     end
  # 
  #     if self.home_score < self.away_score
  #       self.winner_id = self.away_id
  #     end
  #   end
  # 
  # end
  # 
  # # return true if the round home away conbination is nil
  # def self.round_home_away_exist?(round, home, away)
  #   find_by_round_id_and_home_id_and_away_id(round.id, home.id, away.id).nil?
  # end
  # 
  # def self.find_and_collect_by_jornada
  #   collection = {}
  #   jornada = self.jornada
  #   collection[jornada] = [self]
  #   while jornada > 0
  #     jornada = jornada - 1
  #     collection[jornada] = collect_previous_jornada collection[jornada+1]
  #   end    
  # 
  #   collection
  # end
  # 
  # def ready_to_play?
  #   home and away
  # end
  # 
  # def self.jornada_in_words(jornada)
  #   case jornada
  #   when -1
  #     'Champion'
  #   when 1
  #     'Finals'
  #   when 2
  #     'Semifinals'
  #   when 3
  #     'Quarterfinals'
  #   else
  #     "Round #{jornada.ordinalize}"
  #   end
  # end
  # 
  # def self.find_all_games(standing)
  #   find(:all, :conditions => ["round_id = ? and (home_id = ? or away_id = ?) and home_score is not null and away_score is not null", 
  #     standing.round, standing.user, standing.user], :order => "id")
  #   end
  # 
  # 
  #   # def self.final
  #   #   self.root
  #   # end
  # 
  # 
  #   # def self.find_and_collect_by_round
  #   #   collection = {}
  #   #   round = self.final.round
  #   #   collection[round] = [self.final]
  #   #   while round > 0
  #   #     round = round - 1
  #   #     collection[round] = collect_previous_round collection[round+1]
  #   #   end    
  #   # 
  #   #   collection
  #   # end
  # 
  #   # def self.collect_previous_round games_in_round
  #   #   games_in_round.collect {|game| game.children}.flatten
  #   # end
  # 
  #   # def round
  #   #   return 1 if children.blank?
  #   #   1 + children.first.round
  #   # end
  # 
  # 
  #   # def home_next_games
  #   #   # self.next_game
  #   #   self
  #   #   
  #   # end
  #   # 
  #   # def away_next_games
  #   #   # self.next_game
  #   # end
  # 
  # 
  # 
  #   # def jornada
  #   #   return 1 if first_players_previous_game.nil?
  #   #   1 + first_players_previous_game.jornada
  #   # end
  # 
  # 
  # 
  #   # def winner
  #   #   # return nil if game_for_winner.nil?
  #   #   game_for_winner.first_players_previous_game == self ? game_for_winner.player1 : game_for_winner.player2
  #   # end
  # 
  #   # def winner_id= player_id
  #   #   # return nil if game_for_winner.nil?
  #   #   if game_for_winner.first_players_previous_game == self 
  #   #     game_for_winner.player1_id = player_id 
  #   #   else
  #   #     game_for_winner.player2_id = player_id
  #   #   end
  #   #   game_for_winner.save
  #   # end
  # 
  #   # def self.first_round
  #   #   find_leaves([final]).flatten
  #   # end
  # 
  #   protected  
  # 
  #   # def self.find_leaves roots
  #   #   leaves = []
  #   #   roots.each do |game|
  #   #     if game.children.empty?
  #   #       leaves << game
  #   #     else
  #   #       leaves << find_leaves(game.children)
  #   #     end 
  #   #   end
  #   #   leaves
  #   # end



  end