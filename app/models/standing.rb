class Standing < ActiveRecord::Base
  
    belongs_to  :user
    belongs_to  :round,           :dependent => :destroy
    belongs_to  :tournament,      :dependent => :destroy

    # calculate standing for all clashes for round
    def self.calculate_round_standing(round)
      round.standings.each do |standing| 
          @clashes = Clash.find(:all, :conditions => ["meet_id in (?) and user_id = ?", round.meets, standing.user])  
          update_round_user_standing(standing, @clashes)
      end
    end

    # calculate standings for user in round
    def self.update_round_user_standing(standing, clashes)  
      wins, losses, draws, the_points, played = 0, 0, 0, 0, 0
      clashes.each do |clash|
        if (clash.user_x_two == 99999)
          draws += 1
        else
          wins += 1 if clash.one_x_two == clash.user_x_two                  
          losses += 1 if clash.one_x_two != clash.user_x_two
        end
      end 

      # ticker all the results for the user, round conbination and points relate to team activity
      the_points = (wins * standing.round.tournament.points_for_win) + 
                   (draws * standing.round.tournament.points_for_draw) + 
                   (losses * standing.round.tournament.points_for_lose)

      played = wins + draws + losses
      
      # update standing with all calculations
      standing.update_attributes(:wins => wins, :losses => losses, :draws => draws, :points => the_points, :played => played)
    end

    def self.update_round_user_ranking(round)      
      @standings = Standing.find(:all, :conditions =>["round_id = ? and user_id > 0 and played > 0 and archive = false", round.id], 
                                 :order => 'points desc, standings.points desc')

      # default variables
      first, ranking, past_points, last = 0, 0, 0, 0
      @standings.each do |standing| 
        points ||= 0
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
        standing.update_attribute(:ranking, ranking)
      end
    end

    # # calculate number of games played and assigned for user
    # def self.calculate_user_played_assigned_standing(user, round)
    #   @standing = Standing.find(:first, :conditions => ["user_id = ? and round_id = ?", user.id, round.id])
    #   @standing.update_attribute(:played, Clash.user_played(@standing).total)
    #   @standing.update_attribute(:assigned, Clash.user_assigned(@standing).total) 
    # end

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
      find_by_round_id_and_user_id(round, user).nil?
    end

    def self.archive?
      return self.archive
    end

    def self.users_round_standing(round)
       find(:all, 
                :joins => "LEFT JOIN users on users.id = standings.user_id",
                :conditions => ["round_id in (?) and standings.archive = false", round],
                :order => "round_id, points DESC, ranking, users.name")
    end

  end


