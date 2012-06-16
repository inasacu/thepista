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
    self.game.name
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
  
  def self.latest_items(items, user)
		self.where("archive = false and create_at != updated_at").each do |item|
			item << item
		end
		
    # find(:all, :select => "distinct matches.id, matches.user_id, matches.schedule_id, matches.type_id, types.name as type_name, matches.status_at as created_at", 
    #      :joins => "left join groups_users on groups_users.user_id = matches.user_id left join types on types.id = matches.type_id left join schedules on schedules.id = matches.schedule_id",    
    #      :conditions => ["schedules.played = false and groups_users.group_id in (?) and 
    #           age(matches.status_at, matches.created_at) > '00:00:00' and matches.status_at != matches.created_at and matches.status_at >= ?", user.groups, LAST_THREE_DAYS]).each do |item| 
    #   items << item
    # end
    return items 
  end

  def self.current_challenge(users, challenge, page = 1)
		self.where("user_id in (?) and challenge_id = ? and casts.home_score is not null and casts.away_score is not null", users, challenge).joins("left join games on games.id = casts.game_id left join users on users.id = casts.user_id").page(page).order('games.jornada, users.name')
  end
  
  def self.current_casts(user, challenge)
    self.where("casts.user_id = ? and casts.challenge_id = ?", user, challenge).joins("LEFT JOIN games on games.id = casts.game_id").order('games.jornada')
  end
  
  def self.guess_casts(users, challenges, page = 1)
    self.where("user_id in (?) and challenge_id in (?) and points > 0", users, challenges).joins("left join games on games.id = casts.game_id left join users on users.id = casts.user_id").page(page).order('games.jornada, users.name')
  end
    
  def self.ready_casts(user, challenge)
    self.where("user_id = ? and challenge_id = ? and home_score is not null and away_score is not null", user.id, challenge.id).select("count(*) as total").first()
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
    @casts = Cast.where("challenge_id = ?", challenge)
    @casts.each do |cast|
      points = 0
      unless cast.game.home_score.nil? or cast.game.away_score.nil? 
        unless cast.home_score.nil? or cast.away_score.nil? 
          
					is_exact_score = false

					# points for double
					if (cast.home_score.to_i == cast.game.home_score.to_i and cast.away_score.to_i == cast.game.away_score.to_i )
					  points = cast.game.points_for_single.to_i
					  points += cast.game.points_for_double.to_i 
					  points += cast.game.points_for_draw.to_i 
					  points += cast.game.points_for_goal_difference.to_i 
					  points += cast.game.points_for_goal_total.to_i 
					  points += cast.game.points_for_winner.to_i 
					  is_exact_score = true
					end

					# points for single
					if (cast.home_score.to_i == cast.game.home_score.to_i or cast.away_score.to_i == cast.game.away_score.to_i )
					  points = cast.game.points_for_single.to_i unless is_exact_score
					end

					# points for draw
					if (cast.home_score.to_i == cast.away_score.to_i and cast.game.home_score.to_i == cast.game.away_score.to_i )
					  points += cast.game.points_for_draw.to_i unless is_exact_score
					end

					# points for goal difference
					if (cast.home_score.to_f - cast.away_score.to_f == cast.game.home_score.to_f - cast.game.away_score.to_f )
					  points += cast.game.points_for_goal_difference.to_i unless is_exact_score
					end

					# points for goal total
					if (cast.home_score.to_i + cast.away_score.to_i == cast.game.home_score.to_i + cast.game.away_score.to_i )
					  points += cast.game.points_for_goal_total.to_i unless is_exact_score
					end

					# points for winner
					if (cast.home_score.to_i < cast.away_score.to_i and cast.game.home_score.to_i < cast.game.away_score.to_i) or
					    (cast.home_score.to_i > cast.away_score.to_i and cast.game.home_score.to_i > cast.game.away_score.to_i)
					  points += cast.game.points_for_winner.to_i unless is_exact_score
					end
          
        end
      end
      cast.points = points
      cast.save!
    end
  end
  
  def self.calculate_standing(cast)  
    Cast.delay.update_cast_details(cast.challenge)   
    Standing.delay.cup_challenges_user_standing(cast.challenge.cup) 
    Standing.delay.update_cup_challenge_item_ranking(cast.challenge.cup)
  end
    
  # archive or unarchive a cast 
  def self.set_remove_cast(user, challenge)
    @casts = Cast.where("user_id = ? and challenge_id = ?", user.id, challenge.id)
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
