class Standing < ActiveRecord::Base
  
    belongs_to  :user
    belongs_to  :round,           :dependent => :destroy
    belongs_to  :tournament,      :dependent => :destroy

    def self.calculate_round_standing(round)
      total_meets_played = round.games_played

      if total_meets_played.to_i > 1
        previous_to_round_standing(round)  
        update_round_user_ranking(round, true)
      end

      if total_meets_played.to_i > 0
        all_to_round_standing(round)  
        update_round_user_ranking(round, false)
      end

    end

    # calculate standing for all previous clashes for round
    def self.previous_to_round_standing(round)  
        round.users.each do |user|
          @standings = Standing.find(:all, :conditions =>["round_id = ? and user_id > 0 and archive = ?", round, false])

          @standings.each do |standing|  
            @clashes = Clash.find_all_previous_meets(standing.user_id, standing.round_id)
            update_round_user_standing(round, user, standing, @clashes, true)
            previous_clashes = true
          end
        end
    end

    # calculate standing for all previous clashes for round
    def self.all_to_round_standing(round)  
        round.users.each do |user|
          @standings = Standing.find(:all, :conditions =>["round_id = ? and user_id > 0 and archive = ?", round, false])

          @standings.each do |standing|  
            @clashes = Clash.find_all_meets(standing.user_id, standing.round_id)
            update_round_user_standing(round, user, standing, @clashes, false)
            previous_clashes = true
          end
        end
    end

    def self.update_round_user_standing(round, user, standing, clashes, previous_clashes=true)

      # calculate standings for user in round  
      # default variables      
      wins, losses, draws = 0, 0, 0
      played, assigned = 0, 0
      goals_for, goals_against, goals_scored = 0, 0, 0
      prev_wins, prev_losses, prev_draws, prev_played = 0, 0, 0, 0
      the_points, the_previous_played, the_previous_points = 0, 0, 0

      clashes.each do |match|
        if (match.one_x_two == 'X')
          draws += 1
          # prev_draws += 1 if previous_clashes
        else
          wins += 1 if match.one_x_two == match.user_x_two                  
          losses += 1 if match.one_x_two != match.user_x_two

          # if previous_clashes
          #   prev_wins += 1 if match.one_x_two == match.user_x_two          
          #   prev_losses += 1 if match.one_x_two != match.user_x_two 
          # end
        end

        if match.played
          case match.user_x_two
          when "1"
            goals_for += match.round_score.to_i
            goals_against += match.invite_score.to_i
          when "X"
            goals_for += match.round_score.to_i
            goals_against += match.round_score.to_i
          when "2"
            goals_for += match.invite_score.to_i
            goals_against += match.round_score.to_i 
          end
        end 

      end 


      played = Clash.user_played(standing).total
      assigned = Clash.user_assigned(standing).total
      goals_scored = Clash.user_goals_scored(standing).total

      # ticker all the results for the user, round conbination and points relate to team activity
      the_points = (wins * standing.round.points_for_win) + 
                   (draws * standing.round.points_for_draw) + 
                   (losses * standing.round.points_for_lose)

      if previous_clashes
        the_previous_points = the_points
      end

      if played.to_i > 1
        the_previous_played = played.to_i - prev_played 
      end

      # update standing with all calculations
      if previous_clashes
        standing.update_attributes(:wins => wins, :losses => losses, :draws => draws, :played => played, :assigned => assigned.to_i,
                                    :points => the_points, :previous_points => the_previous_points,
                                    :previous_played => the_previous_played, 
                                    :goals_for => goals_for, :goals_against => goals_against, :goals_scored => goals_scored.to_i)
      else
        standing.update_attributes(:wins => wins, :losses => losses, :draws => draws, 
                                    :played => played, :assigned => assigned.to_i,
                                    :points => the_points, 
                                    :goals_for => goals_for, :goals_against => goals_against, :goals_scored => goals_scored.to_i)
      end
    end

    def self.update_round_user_ranking(round, previous_clashes=true)
      # default variables
      first, ranking, past_points, last = 0, 0, 0, 0

      # ranking
      unless previous_clashes
        @standings = Standing.find(:all, 
        :conditions =>["round_id = ? and user_id > 0 and played > 0 and archive = false", round.id], 
        :order => 'points desc, (standings.points / (standings.played * 10)) desc')

      # previous ranking
      else
        @standings = Standing.find(:all, 
        :conditions =>["round_id = ? and user_id > 0 and played > 0 and archive = false", round.id], 
        :order => 'previous_points desc, (standings.points / (standings.played * 10)) desc')
      end

      @standings.each do |standing| 
        points ||= 0

        # current ranking
        unless previous_clashes
          points = standing.points
          # previous ranking
        else  
          points = standing.previous_points
        end

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
        unless previous_clashes
          standing.update_attribute(:ranking, ranking)
          # previous ranking
        else
          standing.update_attribute(:previous_ranking, ranking)
        end

      end
    end

    # calculate number of games played and assigned for user
    def self.calculate_user_played_assigned_standing(user, round)
      @standing = Standing.find(:first, :conditions => ["user_id = ? and round_id = ?", user.id, round.id])
      @standing.update_attribute(:played, Clash.user_played(@standing).total)
      @standing.update_attribute(:assigned, Clash.user_assigned(@standing).total) 
    end

    # archive or unarchive a standing and recalculate round standings
    def self.set_archive_flag(user, round, flag)
      @standing = Standing.find(:first, :conditions => ["user_id = ? and round_id = ?", user.id, round.id])
      @standing.update_attribute(:archive, flag)
      self.calculate_round_standing(round)
    end

    # record if user and round do not exist
    def self.create_user_standing(user, round)
      self.create!(:round_id => round.id, :user_id => user.id) if self.user_round_exists?(user, round)
    end

    # Return true if the user and round nil
    def self.user_round_exists?(user, round)
      # find(:first, :conditions => ["user_id = ? and round_id = ? and archive = ?", user.id, round.id, false]).nil?
      find_by_round_id_and_user_id(round, user).nil?
    end

    def self.archive?
      return self.archive
    end

    def self.users_round_standing(round)
       find(:all, 
                :joins => "LEFT JOIN users on users.id = standings.user_id",
                :conditions => ["round_id in (?) and user_id > 0 and played > 0 and standings.archive = false", round],
                :order => "round_id, points DESC, ranking, users.name")
    end

  end


