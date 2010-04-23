class Standing < ActiveRecord::Base

  belongs_to 	:cup
  belongs_to  :item,      :polymorphic => true
  belongs_to	:challenge
  
  

  # method section
  def self.create_cup_escuadra_standing(cup)  
    cup.escuadras.each do |escuadra|
      Standing.create_cup_item_standing(cup, escuadra)
    end
  end

  def self.create_cup_challenge_standing(cup)  
    cup.challenges.each do |challenge|
      challenge.users.each do |user|
        Standing.create_cup_challenge_item_standing(cup, challenge, user)
      end
    end	
  end 

  # calculate standing for all previous game in item
  def self.calculate_cup_standing(cup)  
    escuadras = []
    cup.escuadras.each {|escuadra| escuadras << escuadra.id} 
    @standings = Standing.find(:all, :conditions =>["cup_id = ? and item_id in (?) and item_type = ?", cup, escuadras, 'Escuadra'])

    @standings.each do |standing|  
      @games = Game.find_all_games(standing)
      update_cup_standing(standing, @games)
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

  # record if user and group do not exist
  def self.create_cup_challenge_item_standing(cup, challenge, item)
    self.create!(:cup => cup, :challenge => challenge, :item => item) if self.cup_challenge_item_exists?(cup, challenge, item)
  end

  # record if user and group do not exist
  def self.create_cup_item_standing(cup, item)
    self.create!(:cup_id => cup, :item => item) if self.cup_item_exists?(cup, item)
  end
  
  def self.cup_escuadras_standing(cup)
    escuadras = []
    cup.escuadras.each {|escuadra| escuadras << escuadra.id} 
    find(:all, 
    :joins => "LEFT JOIN escuadras on escuadras.id = standings.item_id",
    :conditions => ["cup_id = ? and item_id in (?) and item_type = ? and standings.archive = false", cup, escuadras, 'Escuadra'],
    :order => "group_stage_name, points DESC, (goals_for-goals_against) DESC")
  end

  private

  # Return true if the user and group nil
  def self.cup_challenge_item_exists?(cup, challenge, item)
    find(:first, :conditions => ["cup_id = ? and challenge_id = ? and item_id = ? and item_type = ?", cup, challenge, item, item.class.to_s]).nil?
  end

  # Return true if the user and group nil
  def self.cup_item_exists?(cup, item)
    find_by_cup_id_and_item_id_and_item_type(cup, item, item.class.to_s).nil?
  end

end
