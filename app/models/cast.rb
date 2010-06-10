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
  
  def home_ranking
    self.game.home_ranking
  end
  
  def away_ranking
    self.game.away_ranking
  end
  
  def home_stage_name
    self.game.home_stage_name
  end
  
  def away_stage_name
    self.game.away_stage_name
  end
  
  def type_name
    self.game.type_name
  end
  
  def game_played?
    self.game.game_played?
  end
  
  def deadline_at
    self.game.starts_at - 1.day
  end
  
  def self.current_challenge(users, challenge, page = 1)
    self.paginate(:all, :joins => "left join games on games.id = casts.game_id left join users on users.id = casts.user_id",
                  :conditions => ["user_id in (?) and challenge_id = ?", users, challenge], 
                  :order => 'games.jornada, users.name', :page => page, :per_page => CUPS_PER_PAGE)
  end
  
  def self.current_casts(user, challenge)
    find(:all, :joins => "LEFT JOIN games on games.id = casts.game_id",
         :conditions => ["casts.user_id = ? and casts.challenge_id = ?", user, challenge], 
         :order => 'games.jornada')
  end
  
  def self.guess_casts(users, challenges, page = 1)
    self.paginate(:all, :joins => "left join games on games.id = casts.game_id left join users on users.id = casts.user_id",
                  :conditions => ["user_id in (?) and challenge_id in (?) and points > 0", users, challenges], 
                  :order => 'games.jornada, users.name', :page => page, :per_page => CUPS_PER_PAGE)
  end
    
  def self.ready_casts(user, challenge)
    find(:first, :select => "count(*) as total", :conditions => ["user_id = ? and challenge_id = ? and home_score is not null and away_score is not null", user.id, challenge.id])
  end
  
  def self.save_casts(the_cast, cast_attributes)
    the_cast.challenge.casts.each do |cast|
      attributes = cast_attributes[cast.id.to_s]
      cast.attributes = attributes if attributes
      cast.save(false) if (cast.starts_at >= HOURS_BEFORE_GAME)
    end
  end
  
  # points for casts
  # points for single
  # points for double
  # Result  Description Points
  # Correct Result  You predicted the exact result. 30 
  # Correct Draw  You predicted a draw and the game was a draw. 20
  # Correct goal difference You predicted the correct goal difference.  15
  # Correct outcome You predicted the right winner. 10
  # Bonus Points:
  # Group Bonus If you predict the correct winner in a group. 50
  # Final Bonus If you predict the correct final winner.  200
  # :points_for_single            => 1
  # :points_for_double            => 35
  # :points_for_draw              => 25
  # :points_for_goal_difference   => 15
  # :points_for_goal_total        => 5
  # :points_for_winner            => 10
  def self.update_cast_details(challenge)
    @casts = Cast.find(:all, :conditions => ["challenge_id = ?", challenge])
    @casts.each do |cast|
      points = 0
      unless cast.game.home_score.nil? or cast.game.away_score.nil? 
        unless cast.home_score.nil? or cast.away_score.nil? 
          
          # points for single
          if (cast.home_score.to_i == cast.game.home_score.to_i or cast.away_score.to_i == cast.game.away_score.to_i )
            points = cast.game.points_for_single.to_i 
          end
          
          # points for double
          if (cast.home_score.to_i == cast.game.home_score.to_i and cast.away_score.to_i == cast.game.away_score.to_i )
            points += cast.game.points_for_double.to_i 
          end
          
          # points for draw
          if (cast.home_score.to_i == cast.away_score.to_i and cast.game.home_score.to_i == cast.game.away_score.to_i )
            points += cast.game.points_for_draw.to_i 
          end
          
          # points for goal difference
          if (cast.home_score.to_f - cast.away_score.to_f == cast.game.home_score.to_f - cast.game.away_score.to_f )
            points += cast.game.points_for_goal_difference.to_i 
          end

          # points for goal total
          if (cast.home_score.to_i + cast.away_score.to_i == cast.game.home_score.to_i + cast.game.away_score.to_i )
            points += cast.game.points_for_goal_total.to_i 
          end
          
          # points for winner
          if (cast.home_score.to_i < cast.away_score.to_i and cast.game.home_score.to_i < cast.game.away_score.to_i) or
              (cast.home_score.to_i > cast.away_score.to_i and cast.game.home_score.to_i > cast.game.away_score.to_i)
            points += cast.game.points_for_winner.to_i 
          end
          
        end
      end
      cast.points = points
      cast.save!
    end
  end
  
  def self.calculate_standing(cast)  
    Cast.send_later(:update_cast_details, cast.challenge)   
    Standing.send_later(:cup_challenges_user_standing, cast.challenge.cup) 
    Standing.send_later(:update_cup_challenge_item_ranking, cast.challenge.cup)
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
