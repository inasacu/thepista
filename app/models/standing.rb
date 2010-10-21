class Standing < ActiveRecord::Base

  belongs_to 	:cup
  belongs_to	:challenge
  belongs_to  :item,          :polymorphic => true
  
  validates_format_of   :group_stage_name,            :with =>  /^[A-Z]*\z/
  
  attr_accessible       :group_stage_name
    
  # method section
  def self.create_cup_escuadra_standing(cup)
    cup.escuadras.each do |escuadra|
      Standing.create_cup_item_standing(cup, escuadra)
    end
  end

  def self.create_cup_challenge_standing(challenge)
    challenge.users.each do |user|
      Standing.create_cup_challenge_item_standing(challenge.cup, challenge, user)
    end
  end 

  # calculate standing for all game in item
  def self.calculate_cup_standing(cup)  
    escuadras = []
    cup.escuadras.each {|escuadra| escuadras << escuadra.id} 
    @standings = Standing.find(:all, :conditions =>["cup_id = ? and item_id in (?) and item_type = ?", cup, escuadras, 'Escuadra'])

    @standings.each do |standing|  
      @games = Game.find_all_games(standing)
      update_cup_standing(standing, @games)
    end

    @group_stages = Standing.find(:all, :select => "distinct cup_id, group_stage_name", :conditions =>["cup_id = ?", cup.id], :order => "group_stage_name")
    @group_stages.each do |group_stage|    
      self.update_cup_group_stage_ranking(group_stage)
    end    
  end
 
  def self.update_cup_standing(standing, games)
    # default variables      
    wins, losses, draws = 0, 0, 0
    played, the_points, the_games = 0, 0, 0
    goals_for, goals_against = 0, 0

    # calculate score for home user
    games.each do |game|
      if (game.home_score.to_i == game.away_score.to_i and game.home_id == standing.item_id)
        draws += 1
      else
        wins += 1 if (game.home_score.to_i > game.away_score.to_i and game.home_id == standing.item_id)                 
        losses += 1 if (game.home_score.to_i < game.away_score.to_i and game.home_id == standing.item_id)
      end
    end

    # calculate score for away user
    games.each do |game|
      if (game.home_score.to_i == game.away_score.to_i and game.away_id == standing.item_id)
        draws += 1
      else
        wins += 1 if (game.home_score.to_i < game.away_score.to_i and game.away_id == standing.item_id)                 
        losses += 1 if (game.home_score.to_i > game.away_score.to_i and game.away_id == standing.item_id)
      end
    end

    games.each do |game|
      if game.home_id == standing.item_id
        goals_for += game.home_score.to_i 
        goals_against += game.away_score.to_i 
      else
        goals_for += game.away_score.to_i
        goals_against += game.home_score.to_i 
      end
    end

    # ticker all the results for the user, group conbination and points relate to team activity
    the_points = (wins * standing.cup.points_for_win) + 
    (draws * standing.cup.points_for_draw) + 
    (losses * standing.cup.points_for_lose)

    the_games = wins + losses + draws

    # update standing with all calculations
    standing.update_attributes(:wins => wins, :losses => losses, :draws => draws, 
                               :points => the_points, :goals_for => goals_for, :goals_against => goals_against,
                               :played => the_games)
  end

  def self.update_cup_group_stage_ranking(standing)
    # default variables
    ranking = 0
    
    @standings = Standing.find(:all, :conditions =>["cup_id = ? and group_stage_name = ?", standing.cup_id, standing.group_stage_name], 
    :order => "points desc, (goals_for-goals_against) desc, goals_for desc, goals_against")
    
     @standings.each do |standing| 
        ranking += 1 if standing.played > 0
        standing.update_attribute(:ranking, ranking)
      end      
  end

  def self.update_cup_challenge_item_ranking(cup, item='User')
    cup.challenges.each do |challenge|
      # default variables
      ranking, past_points, last = 0, 0, 1

      # ranking
      @standings = Standing.find(:all, :conditions =>["challenge_id = ? and item_type = ? and archive = false", challenge, item], 
      :order => 'points desc')

      @standings.each do |standing|  

        if (past_points > standing.points) 
          last = 1          
        end
        
        ranking += last # if (past_points > 0 or standing.points > 0)
        last = 0
        past_points = standing.points 

        standing.update_attribute(:ranking, ranking)
      end
    end
  end

  # record if user and group do not exist
  def self.create_cup_challenge_item_standing(cup, challenge, item)
    self.create!(:cup => cup, :challenge => challenge, :item => item) if self.cup_challenge_item_exists?(cup, challenge, item)
  end

  # record if cup and item do not exist
  def self.create_cup_item_standing(cup, item)
    self.create!(:cup => cup, :item => item, :group_stage_name => 'A') if self.cup_item_exists?(cup, item)
  end
  
  def self.cup_escuadras_standing(cup)
    escuadras = []
    cup.escuadras.each {|escuadra| escuadras << escuadra.id} 
    find(:all, :joins => "LEFT JOIN escuadras on escuadras.id = standings.item_id",
    :conditions => ["standings.cup_id = ? and standings.item_id in (?) and standings.item_type = ? and standings.archive = false", cup, escuadras, 'Escuadra'],
    :order => "standings.group_stage_name, standings.points desc, (standings.goals_for-standings.goals_against) desc, standings.goals_for desc, 
              standings.goals_against, escuadras.name")
  end

  def self.cup_items_standing(cup, item) 
    find(:all, 
    :joins => "LEFT JOIN users on users.id = standings.item_id",
    :conditions => ["cup_id = ? and item_type = ? and standings.archive = false", cup, item.class.to_s],
    :order => "points desc, users.name")
  end
    
  def self.cup_challenge_users_standing(challenge) 
    find(:all, 
    :joins => "LEFT JOIN users on users.id = standings.item_id",
    :conditions => ["cup_id = ? and challenge_id = ? and standings.archive = false", challenge.cup, challenge],
    :order => "points desc, users.name")
  end
  
  def self.cup_challenges_standing(challenge)
    find(:all, :conditions => ["challenge_id = ? and standings.archive = false",  challenge], :order => "points desc")
  end
  
  def self.cup_challenges_user_standing(cup)
    cup.challenges.each do |challenge|
      challenge.users.each do |user|
        @standings = Standing.find(:all, :conditions => ["challenge_id = ? and item_id = ? and item_type = ?", challenge.id, user.id, user.class.to_s])
        @standings.each do |standing|
          points = 0

          cast = Cast.find(:first, :select => "sum(points) as points", :conditions => ["challenge_id = ? and user_id = ?", challenge, user])
          points = cast.points.to_i unless cast.nil?    

          standing.points = points
          standing.save!
        end
      end
    end
  end
  
  # archive or unarchive a standing
  def self.set_archive_flag(item, challenge, flag)
    @standing = Standing.find(:first, :conditions => ["challenge_id = ? and item_id = ? and item_type = ?", challenge.id, item.id, item.class.to_s])
    @standing.update_attribute(:archive, flag)
  end
  
  def self.save_standings(the_standing, standing_attributes)
    the_standing.cup.standings.each do |standing|
      attributes = standing_attributes[standing.id.to_s]
      standing.attributes = attributes if attributes
      standing.save(false)
    end
  end

  private
  # Return true if the user and group nil
  def self.cup_challenge_item_exists?(cup, challenge, item)
    find(:first, :conditions => ["cup_id = ? and challenge_id = ? and item_id = ? and item_type = ?", cup, challenge, item, item.class.to_s]).nil?
  end

  # Return true if the cup and item nil
  def self.cup_item_exists?(cup, item)
    find_by_cup_id_and_item_id_and_item_type(cup, item, item.class.to_s).nil?
  end

end
