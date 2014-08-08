# == Schema Information
#
# Table name: scorecards
#
#  id               :integer          not null, primary key
#  group_id         :integer
#  user_id          :integer
#  wins             :integer          default(0)
#  draws            :integer          default(0)
#  losses           :integer          default(0)
#  points           :float            default(0.0)
#  ranking          :integer          default(0)
#  played           :integer          default(0)
#  assigned         :integer          default(0)
#  goals_for        :integer          default(0)
#  goals_against    :integer          default(0)
#  goals_scored     :integer          default(0)
#  previous_points  :integer          default(0)
#  previous_ranking :integer          default(0)
#  previous_played  :integer          default(0)
#  payed            :integer          default(0)
#  archive          :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#

class Scorecard < ActiveRecord::Base 
  
  belongs_to :user
  belongs_to :group
  
  def self.calculate_group_scorecard(group)
    total_schedules_played = group.games_played

    if total_schedules_played.to_i > 1
      previous_to_group_scorecard(group)
      update_group_user_ranking(group, true)
    end

    if total_schedules_played.to_i > 0
      all_to_group_scorecard(group)  
      update_group_user_ranking(group, false)
    end  
  end
    
  # calculate scorecard for all previous matches for group
  def self.previous_to_group_scorecard(group)  
      group.users.each do |user|
        @scorecards = Scorecard.find(:all, :conditions =>["group_id = ? and user_id > 0 and archive = ?", group, false])

        @scorecards.each do |scorecard|  
          # @matches = Match.find_all_previous_schedules(scorecard.user_id, scorecard.group_id)
          @matches = Match.find_all_schedules(scorecard.user_id, scorecard.group_id)
          update_group_user_scorecard(group, user, scorecard, @matches, true)
          previous_matches = true
          
          # run for basket stats if team is basket
          # update_group_user_scorecard_basket(group, user, scorecard, @matches) if group.is_basket?
        end
      end
  end

  # calculate scorecard for all previous matches for group
  def self.all_to_group_scorecard(group)  
      group.users.each do |user|
        @scorecards = Scorecard.find(:all, :conditions =>["group_id = ? and user_id > 0 and archive = ?", group, false])

        @scorecards.each do |scorecard|  
          @matches = Match.find_all_schedules(scorecard.user_id, scorecard.group_id, false)
          update_group_user_scorecard(group, user, scorecard, @matches, false)
          previous_matches = true
          
          # run for basket stats if team is basket
          # update_group_user_scorecard_basket(group, user, scorecard, @matches) if group.is_basket?
        end
      end
  end
  
  def self.update_group_user_scorecard(group, user, scorecard, matches, previous_matches=true)

    # calculate scorecards for user in group  
    # default variables      
    wins, losses, draws = 0, 0, 0
    played, assigned = 0, 0
    goals_for, goals_against, goals_scored, assists = 0, 0, 0, 0
    prev_wins, prev_losses, prev_draws, prev_played = 0, 0, 0, 0
    the_points, the_previous_played, the_previous_points = 0, 0, 0

    matches.each do |match|
      if (match.one_x_two == 'X')
        draws += 1
        # prev_draws += 1 if previous_matches
      else
        wins += 1 if match.one_x_two == match.user_x_two                  
        losses += 1 if match.one_x_two != match.user_x_two

        # if previous_matches
        #   prev_wins += 1 if match.one_x_two == match.user_x_two          
        #   prev_losses += 1 if match.one_x_two != match.user_x_two 
        # end
      end
      
      if match.played
        case match.user_x_two
        when "1"
          goals_for += match.group_score.to_i
          goals_against += match.invite_score.to_i
        when "X"
          goals_for += match.group_score.to_i
          goals_against += match.group_score.to_i
        when "2"
          goals_for += match.invite_score.to_i
          goals_against += match.group_score.to_i 
        end
      end 
      
    end 


    played = Match.user_played(scorecard).total
    assigned = Match.user_assigned(scorecard).total
    goals_scored = Match.user_goals_scored(scorecard).total

    # ticker all the results for the user, group conbination and points relate to team activity
    the_points = (wins * scorecard.group.points_for_win) + 
                 (draws * scorecard.group.points_for_draw) + 
                 (losses * scorecard.group.points_for_lose)
    
    if previous_matches
      the_previous_points = the_points
    end
    
    if played.to_i > 1
      the_previous_played = played.to_i - prev_played 
    end
    
    # update scorecard with all calculations
    if previous_matches
      scorecard.update_attributes(:wins => wins, :losses => losses, :draws => draws, :played => played, :assigned => assigned.to_i,
                                  :points => the_points, :previous_points => the_previous_points, :previous_played => the_previous_played, 
                                  :goals_for => goals_for, :goals_against => goals_against, :goals_scored => goals_scored.to_i)
    else
      scorecard.update_attributes(:wins => wins, :losses => losses, :draws => draws, :played => played, :assigned => assigned.to_i,
                                  :points => the_points, :goals_for => goals_for, :goals_against => goals_against, :goals_scored => goals_scored.to_i)
    end
  end
  

  
  def self.update_group_user_ranking(group, previous_matches=true)
    # default variables
    first, ranking, past_points, last = 0, 0, 0, 0

    # ranking
    unless previous_matches
      @scorecards = Scorecard.find(:all, :joins => "LEFT JOIN users on users.id = scorecards.user_id",
                        :conditions =>["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false and users.archive = false", group.id], 
                        :order => 'points desc, users.name')
      
    # previous ranking
    else
      @scorecards = Scorecard.find(:all, :joins => "LEFT JOIN users on users.id = scorecards.user_id",
                      :conditions =>["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false and users.archive = false", group.id], 
                      :order => 'scorecards.previous_points desc, users.name')
    end

    @scorecards.each do |scorecard| 
      points ||= 0

      # current ranking
      unless previous_matches
        points = scorecard.points
        # previous ranking
      else  
        points = scorecard.previous_points
      end

      if first != scorecard.group_id 
        first, ranking, past_points, last = scorecard.group_id, 0, 0, 1
      end 

      # using ranking system, where if two users have same points ranking is the same
      # if (past_points == points) 
      #   last += 1          
      # else
      #   ranking += last
      #   last = 1          
      # end
      
      # using european ranking system where regardless of users having same points, ranking is based on points and name order 
      ranking += 1
      past_points = points  

      the_scorecard = Scorecard.find(scorecard.id)
      
      # current ranking
      unless previous_matches
        the_scorecard.update_attribute(:ranking, ranking)
        # previous ranking
      else
        the_scorecard.update_attribute(:previous_ranking, ranking)
      end

    end
  end

  # calculate number of games played and assigned for user
  def self.calculate_user_played_assigned_scorecard(user, group)
    @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user.id, group.id])
    @scorecard.update_attribute(:played, Match.user_played(@scorecard).total)
    @scorecard.update_attribute(:assigned, Match.user_assigned(@scorecard).total) 
  end

  # archive or unarchive a scorecard and recalculate group scorecards
  def self.set_archive_flag(user, group, flag, reset_scorecard=true)
    @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user.id, group.id])
    @scorecard.update_attribute(:archive, flag)
    # self.calculate_group_scorecard(group) if reset_scorecard

    if reset_scorecard
      self.delay.calculate_group_scorecard(group) if USE_DELAYED_JOBS
      self.calculate_group_scorecard(group) unless USE_DELAYED_JOBS
    end
  end

  # record if group does not exist
  def self.create_group_scorecard(group) 
    self.create!(:group_id => group.id) if self.group_exists?(group)
  end
  
  # record if user and group do not exist
  def self.create_user_scorecard(user, group)
    self.create!(:group_id => group.id, :user_id => user.id) if self.user_group_exists?(user, group)
  end
  
  # Return true if the group nil
  def self.group_exists?(group)
    find(:first, :conditions => ["group_id = ? and archive = ?", group.id, false]).nil?
  end
  
  # Return true if the user and group nil
  def self.user_group_exists?(user, group)
    find(:first, :conditions => ["user_id = ? and group_id = ? and archive = ?", user.id, group.id, false]).nil?
  end
  
  def self.archive?
    return self.archive
  end
  
	def self.has_played_schedule?(group)
			!find(:first, :joins => "JOIN schedules on scorecards.group_id = schedules.group_id", :conditions => ["schedules.played = true and scorecards.group_id = ? and scorecards.played > 0", group]).nil?
	end
	
  def self.users_group_scorecard(group, sort="")
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }
    
    if played_games > 0
    the_sort = "scorecards.points DESC, scorecards.ranking, users.name"
    the_sort = "#{sort}, #{the_sort}" if (sort != " ASC" and sort != " DESC" and !sort.blank? and !sort.empty?) 
    
     find(:all, :select => "scorecards.*, matches.type_id,  
                            (100 * scorecards.points / (scorecards.played * groups.points_for_win)) as coeficient,
                            scorecards.points * (scorecards.points / (scorecards.played * groups.points_for_win)) as coeficient_points,
														(scorecards.points / (scorecards.played * groups.points_for_win) * 100) as coeficient_percent,
                            (100 * scorecards.played / #{played_games}) as coeficient_played",
                :joins => "LEFT JOIN groups on groups.id = scorecards.group_id
                         LEFT JOIN users on users.id = scorecards.user_id 
                         LEFT JOIN matches on matches.user_id = scorecards.user_id",
                :conditions => ["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false 
                               and matches.schedule_id = ? and matches.archive = false and users.archive = false", group, the_schedules.first.id],
                :order => the_sort)
    else
      return nil
    end
  end
	

	def self.get_active_players(group)
		the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and played = true", group], :order => "starts_at desc")
    played_games = 0
    the_schedules.each {|schedule| played_games += 1 }

		played_games = 1 if played_games == 0
		
		find(:all, :select => "(100 * scorecards.played / #{played_games}) as coeficient_played",
							:conditions => ["scorecards.group_id = ? and (100 * scorecards.played / 1) > 19", group])
	end
  
  def self.latest_items(items, group)
      find(:all, :select => "distinct scorecards.id, scorecards.group_id, scorecards.user_id, scorecards.played, 
                            (100 * scorecards.played / 34) as coeficient_played, scorecards.updated_at as created_at",    
                 :conditions => ["scorecards.group_id in (?) and scorecards.user_id > 0 and
                                  scorecards.played > 0 and scorecards.archive = false and scorecards.updated_at >= ?", group, LAST_WEEK],
                 :order => "coeficient_played DESC", 
                 :limit => 3).each do |item| 
        items << item
      end
    return items 
  end

end
