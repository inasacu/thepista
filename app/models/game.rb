class Game < ActiveRecord::Base

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
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/
  validates_numericality_of     :jornada,                         :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 999

  validates_numericality_of     :home_ranking,                    :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8,    :allow_nil => true
  validates_numericality_of     :away_ranking,                    :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 8,    :allow_nil => true  
  validates_numericality_of     :home_score,                      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 300,  :allow_nil => true
  validates_numericality_of     :away_score,                      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 300,  :allow_nil => true
  
  # validates_presence_of         :home_stage_name,                                                     :allow_nil => true
  # validates_length_of           :home_stage_name,                 :is => 1,                           :allow_nil => true
  # validates_format_of           :home_stage_name,                 :with => /^[-A-Z]+$/,               :allow_nil => true
  # validates_presence_of         :away_stage_name,                                                     :allow_nil => true
  # validates_length_of           :away_stage_name,                 :is => 1,                           :allow_nil => true
  # validates_format_of           :away_stage_name,                 :with => /^[-A-Z]+$/,               :allow_nil => true
  
  validates_numericality_of     :points_for_single,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
  validates_numericality_of     :points_for_double,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
  validates_numericality_of     :points_for_draw,                 :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
  validates_numericality_of     :points_for_goal_difference,      :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
  validates_numericality_of     :points_for_goal_total,           :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true
  validates_numericality_of     :points_for_winner,               :greater_than_or_equal_to => 0,       :less_than_or_equal_to => 100,  :allow_nil => true

  validates_presence_of         :starts_at, :ends_at, :reminder_at 

  # variables to access
  attr_accessible :concept, :starts_at, :ends_at, :reminder_at, :deadline_at
  attr_accessible :points_for_single, :points_for_double, :points_for_draw, :points_for_goal_difference, :points_for_goal_total, :points_for_winner
  attr_accessible :cup_id, :home_id, :away_id, :winner_id, :next_game_id, :jornada, :round, :type_name
  attr_accessible :home_score, :away_score, :played, :home_ranking, :away_ranking, :home_stage_name, :away_stage_name
  
  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :concept, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show", "petition"]
                   
  before_update :set_game_winner
  after_update  :calculate_standing

  # method section 
  def self.group_stage_games(cup, page = 1)
    self.paginate(:all, 
    :conditions => ["cup_id = ? and type_name = 'GroupStage'", cup],
    :order => 'jornada', :page => page, :per_page => ESCUADRAS_PER_PAGE)
  end

  def self.group_round_games(cup, page = 1)
    self.paginate(:all, 
    :conditions => ["cup_id = ? and (type_name != 'GroupStage' or type_name is null)", cup],
    :order => 'jornada', :page => page, :per_page => ESCUADRAS_PER_PAGE)
  end

  def self.upcoming_games(hide_time)
    with_scope :find => {:conditions=>{:starts_at => YESTERDAY_TO_TODAY, :played => false}, :order => "starts_at"} do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
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
    find(:all, :conditions => ["cup_id = ? and (home_id = ? or away_id = ?) and home_score is not null and away_score is not null and type_name = 'GroupStage'", 
      standing.cup_id, standing.item_id, standing.item_id], :order => "id")
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
  def self.set_final_stage(cup)
    @first_games = Game.find(:all, :conditions => ["cup_id = ? and type_name = 'FirstGame' and (home_id is null or away_id is null)", cup], :order => "id")
    @first_games.each do |first|
      standing = Standing.find(:first, 
      :conditions => ["cup_id = ? and item_type = 'Escuadra' and group_stage_name = ? and ranking = ?", cup.id, first.home_stage_name, first.home_ranking])
      first.home_id = standing.item_id

      standing = Standing.find(:first, 
      :conditions => ["cup_id = ? and item_type = 'Escuadra' and group_stage_name = ? and ranking = ?", cup.id, first.away_stage_name, first.away_ranking])
      first.away_id = standing.item_id
      first.save!
    end
  end
  
  def calculate_standing
    Standing.send_later(:calculate_cup_standing, self.cup)
    Game.send_later(:update_cast_details, self.cup)
    Game.send_later(:set_final_stage, self.cup) if self.all_group_stage_played(self.cup)
  end
  
  def self.update_cast_details(cup)
    @cast = nil
    cup.challenges.each do |challenge|       
      Cast.send_later(:update_cast_details, challenge)
      @cast = challenge.casts.first if @cast == ''
    end
    Cast.calculate_standing(@cast) unless (@cast == nil)
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