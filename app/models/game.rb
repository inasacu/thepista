class Game < ActiveRecord::Base

  acts_as_tree :foreign_key => :next_game_id

  alias_method :next_game, :parent

  belongs_to :cup

  belongs_to :winner,     :class_name => 'Escuadra',  :foreign_key => 'winner_id' 
  belongs_to :home,       :class_name => 'Escuadra',  :foreign_key => 'home_id' 
  belongs_to :away,       :class_name => 'Escuadra',  :foreign_key => 'away_id'

  belongs_to :next_game,  :class_name => 'Game',  :foreign_key => 'next_game_id'

  belongs_to :home_escuadra,     :class_name => "Escuadra",   :foreign_key => "home_id"
  belongs_to :invite_escuadra,   :class_name => "Escuadra",   :foreign_key => "invite_id"

  # validations   
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/
  validates_numericality_of     :jornada,                         :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 999

  # validates_numericality_of     :home_score,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 300
  # validates_numericality_of     :away_score,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 300

  validates_presence_of         :starts_at, :ends_at, :reminder_at
  # , :home_id, :away_id

  # variables to access
  attr_accessible :concept, :starts_at, :ends_at, :reminder_at, :points_for_single, :points_for_double
  attr_accessible :cup_id, :home_id, :away_id, :winner_id, :next_game_id, :jornada, :round, :type_name
  attr_accessible :home_score, :away_score, :played

  # friendly url and removes id
  # has_friendly_id :concept, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]


  before_update :set_game_winner
  after_update  :calculate_standing

  # method section 
  def self.group_stage_games(cup, page = 1)
    self.paginate(:all, 
    :conditions => ["cup_id = ? and type_name = 'GroupStage'", cup],
    :order => 'jornada', :page => page, :per_page => CUPS_PER_PAGE)
  end

  def self.group_round_games(cup, page = 1)
    self.paginate(:all, 
    :conditions => ["cup_id = ? and type_name != 'GroupStage'", cup],
    :order => 'jornada, starts_at', :page => page, :per_page => CUPS_PER_PAGE)
  end

  def self.upcoming_games(hide_time)
    with_scope :find => {:conditions=>{:starts_at => ONE_MONTH_FROM_TODAY, :played => false}, :order => "starts_at"} do
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
  
  def self.last_cup_game(cup)
    find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?)", cup])
  end

  def game_played?
    played == true
  end

  def not_played?
    played == false
  end
  
  def self.all_cup_games_played(cup)
      if self.count(:conditions => ["cup_id = ? and played is false and type_name = 'GroupStage'", cup]) > 0
        return false
      end
      return true
    end

  def self.find_all_games(standing)
    find(:all, :conditions => ["cup_id = ? and (home_id = ? or away_id = ?) and home_score is not null and away_score is not null", 
      standing.cup_id, standing.item_id, standing.item_id], :order => "id")
  end






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
    
    # return true if the round home away conbination is nil
    def self.cup_home_away_exist?(cup, home, away)
      find_by_cup_id_and_home_id_and_away_id(cup, home, away).nil?
    end

    private

    def calculate_standing
      Standing.calculate_cup_standing(self.cup)
    end

    def set_game_winner  
      unless self.home_score.nil? or self.away_score.nil?
        if self.home_score > self.away_score
          self.winner_id = self.home_id
        end  
        if self.home_score < self.away_score
          self.winner_id = self.away_id
        end
        self.played = true
      end  
    end

    def validate
      # self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
      #  self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      #  self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
      self.errors.add(:home_id, I18n.t(:must_be_different)) if (self.home_id == self.away_id and !self.home_id.nil? and !self.away.nil?) 
    end

  end