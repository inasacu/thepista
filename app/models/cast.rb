class Cast < ActiveRecord::Base

  belongs_to  :challenge
  belongs_to  :game
  belongs_to  :user

  # valications
  validates_numericality_of     :home_score,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999, :allow_nil => true
  validates_numericality_of     :away_score,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999, :allow_nil => true
  
  # variables to access
  attr_accessible :deadline_at, :home_score, :away_score, :challenge_id, :user_id, :game_id

  def home_id
    self.game.home_id
  end
  
  def away_id
    self.game.away_id
  end
  
  def jornada
    self.game.jornada
  end
  
  def concept
    self.game.concept
  end
  
  def starts_at
    self.game.starts_at
  end
  
  def ends_at
    self.game.ends_at
  end
  
  def home
    self.game.home
  end
  
  def away
    self.game.away
  end
  
  def game_played?
    self.game.game_played?
  end
  
  def deadline_at
    self.game.starts_at - 1.day
  end
  
  def self.current_challenge(user, challenge, page = 1)
    self.paginate(:all, :conditions => ["user_id = ? and challenge_id = ?", user.id, challenge.id], :order => 'id', :page => page, :per_page => CUPS_PER_PAGE)
  end
  
  def self.current_casts(user, challenge)
    find(:all, :conditions => ["user_id = ? and challenge_id = ?", user.id, challenge.id], :order => 'id', :limit => CUPS_PER_PAGE)
  end
  
  def self.save_casts(the_cast, cast_attributes)
    the_cast.challenge.casts.each do |cast|
      attributes = cast_attributes[cast.id.to_s]
      cast.attributes = attributes if attributes
      cast.save(false)
    end
  end
  
  def self.update_cast_details(challenge, user)
    @casts = Cast.find(:all, :conditions => ["challenge_id = ? and user_id = ?", challenge, user])
    @casts.each do |cast|
      points = 0

      unless cast.home_score.nil? or cast.away_score.nil?
        points += cast.game.points_for_single if (cast.home_score.to_i == cast.game.home_score.to_i or cast.away_score.to_i == cast.game.away_score.to_i )
        points += cast.game.points_for_double if (cast.home_score.to_i == cast.game.home_score.to_i and cast.away_score.to_i == cast.game.away_score.to_i )
        cast.points = points
        cast.save!
      end
    end
    Standing.cup_challenges_user_standing(challenge.cup) 
    Standing.update_cup_challenge_item_ranking(challenge.cup)
  end
    
  # archive or unarchive a cast 
  def self.set_remove_cast(user, challenge)
    @casts = Cast.find(:all, :conditions => ["user_id = ? and challenge_id = ?", user.id, challenge.id])
    @casts.each {|cast| cast.destroy}
  end
  
  # create a record in the cast table for teammates in group team
  def self.create_challenge_cast(challenge)
    challenge.cup.games.each do |game|
      challenge.users.each do |user|
        self.create!(:challenge_id => challenge.id, :user_id => user.id, :game_id => game.id) if self.challenge_cup_game_user_exists?(challenge, game, user)
      end
    end
  end

  # return true if the challenge cup game user conbination is nil
  def self.challenge_cup_game_user_exists?(challenge, game, user)
    find_by_challenge_id_and_game_id_and_user_id(challenge, game, user).nil?
  end 

end
