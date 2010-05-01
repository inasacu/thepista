class Cast < ActiveRecord::Base

  belongs_to  :challenge
  belongs_to  :game
  belongs_to  :user

  # valications
  # validates_numericality_of     :home_score,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999
  # validates_numericality_of     :away_score,       :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999
  
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
