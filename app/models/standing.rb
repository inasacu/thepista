class Standing < ActiveRecord::Base

  belongs_to :cup
  # belongs_to :round
  # belongs_to :user
  belongs_to :item,           :polymorphic => true

  # # variables to access
  # attr_accessible :cup_id, :round_id, :user_id
  # attr_accessible :wins, :draws, :losses, :points, :ranking, :played

  # method section
  def self.create_cup_round_standing(cup, round)
    @games = Game.find(:all, :conditions => ["cup_id = ? and round_id = ? and type_name = 'GroupStage'", cup.id, round.id])

    @games.each do |game|  
      Standing.create_cup_round_user_standing(game.cup_id, game.round_id, game.home_id)
      Standing.create_cup_round_user_standing(game.cup_id, game.round_id, game.away_id)
    end
  end

  def self.calculate_round_standing(round)
    all_to_round_standing(round)  
    update_round_ranking(round)
  end

  # calculate standing for all previous game in roundup
  def self.all_to_round_standing(round)  
    @standings = Standing.find(:all, :conditions =>["round_id = ?", round])

    @standings.each do |standing|  
      @games = Game.find_all_games(standing)
      update_round_standing(round, standing, @games)
    end
  end

  def self.update_round_standing(round, standing, games)
    #   # default variables      
    wins, losses, draws = 0, 0, 0
    played, the_points, the_games = 0, 0, 0

    # calculate score for home user
    games.each do |game|
      if (game.home_score.to_i == game.away_score.to_i and game.home_id == standing.user_id)
        draws += 1
      else
        wins += 1 if (game.home_score.to_i > game.away_score.to_i and game.home_id == standing.user_id)                 
        losses += 1 if (game.home_score.to_i < game.away_score.to_i and game.home_id == standing.user_id)
      end
    end

    # calculate score for away user
    games.each do |game|
      if (game.home_score.to_i == game.away_score.to_i and game.away_id == standing.user_id)
        draws += 1
      else
        wins += 1 if (game.home_score.to_i < game.away_score.to_i and game.away_id == standing.user_id)                 
        losses += 1 if (game.home_score.to_i > game.away_score.to_i and game.away_id == standing.user_id)
      end
    end

    # ticker all the results for the user, group conbination and points relate to team activity
    the_points = (wins * standing.cup.points_for_win) + 
    (draws * standing.cup.points_for_draw) + 
    (losses * standing.cup.points_for_lose)

    the_games = wins + losses + draws

    # update standing with all calculations
    standing.update_attributes(:wins => wins, :losses => losses, :draws => draws, :points => the_points, :played => the_games)
  end

  def self.update_round_ranking(round)
    # default variables
    first, ranking, past_points, last = 0, 0, 0, 0

    # ranking
    @standings = Standing.find(:all, :conditions =>["round_id", round], :order => 'points desc')

    @standings.each do |standing| 
      points ||= 0

      # current ranking
      points = standing.points

      if first != standing.round_id 
        first, ranking, past_points, last = standing.round_id, 0, 0, 1
      end 

      if (past_points == points) 
        last += 1          
      else
        ranking += last
        last = 1          
      end
      past_points = points  

      # current ranking
      standing.update_attribute(:ranking, ranking)

    end
  end

  # calculate cup round ranking
  # def self.update_cup_round_ranking(cup, round)
  #   # default variables
  #   first, ranking, past_points, last = 0, 0, 0, 0
  # 
  #   # @standings = Standing.find(:all, :cup_id => cup.id, :round_id => round.id,
  #   @standings = Standing.find(:all, :conditions => ["cup_id = ? and round_id = ?", cup.id, round.id],
  #   :order => 'points DESC, (standings.points / (standings.played * 10)) DESC')
  # 
  #   @standings.each do |standing| 
  #     points ||= 0
  # 
  #     # current ranking
  #     points = standing.points
  # 
  #     if first != standing.cup_id 
  #       first, ranking, past_points, last = standing.cup_id, 0, 0, 1
  #     end 
  # 
  #     if (past_points == points) 
  #       last += 1          
  #     else
  #       ranking += last
  #       last = 1          
  #     end
  #     past_points = points  
  # 
  #     # current ranking
  #     standing.ranking = ranking
  #     standing.save!
  #   end
  # end

  # record if user and group do not exist
  def self.create_cup_round_user_standing(cup, round, user)
    self.create!(:cup_id => cup, :round_id => round,  :user_id => user) if self.cup_round_user_exists?(cup, round, user)
    # self.create!(:cup_id => cup, :round_id => round,  :user_id => user)
  end

  # Return true if the user and group nil
  def self.cup_round_user_exists?(cup, round, user)
    find_by_cup_id_and_round_id_and_user_id(cup, round, user).nil?
  end

end


