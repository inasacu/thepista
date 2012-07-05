# TABLE "scorecards"
# t.integer  "group_id"
# t.integer  "user_id"
# t.integer  "wins"                
# t.integer  "draws"               
# t.integer  "losses"              
# t.float    "points"              
# t.integer  "ranking"             
# t.integer  "played"              
# t.integer  "assigned"            
# t.integer  "goals_for"           
# t.integer  "goals_against"       
# t.integer  "goals_scored"        
# t.integer  "previous_points"     
# t.integer  "previous_ranking"    
# t.integer  "previous_played"     
# t.integer  "payed"               
# t.boolean  "archive"             
# t.datetime "created_at"
# t.datetime "updated_at"
# t.datetime "season_s_at"
# t.integer  "field_goal_attempt"  
# t.integer  "field_goal_made"     
# t.integer  "free_throw_attempt"  
# t.integer  "free_throw_made"     
# t.integer  "three_point_attempt" 
# t.integer  "three_point_made"    
# t.integer  "rebounds_defense"    
# t.integer  "rebounds_offense"    
# t.integer  "minutes_played"      
# t.integer  "assists"             
# t.integer  "steals"              
# t.integer  "blocks"              
# t.integer  "turnovers"           
# t.integer  "personal_fouls"      
# t.integer  "started"

class Scorecard < ActiveRecord::Base 

  # tagging
  # acts_as_taggable_on :tags
  
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
          update_group_user_scorecard_basket(group, user, scorecard, @matches) if group.is_basket?
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
          update_group_user_scorecard_basket(group, user, scorecard, @matches) if group.is_basket?
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
  
  def self.update_group_user_scorecard_basket(group, user, scorecard, matches)

    # calculate scorecards for user in group basket 
    # default variables  
    field_goal_attempt, field_goal_made = 0, 0
  	free_throw_attempt, free_throw_made = 0, 0
  	three_point_attempt, three_point_made = 0, 0
  	rebounds_defense, rebounds_offense = 0, 0, 0
  	minutes_played, assists, steals = 0, 0, 0
  	blocks, turnovers, personal_fouls, started = 0, 0, 0, 0

    matches.each do |match|
      field_goal_attempt += match.field_goal_attempt
      field_goal_made += match.field_goal_made
    	free_throw_attempt += match.free_throw_attempt
    	free_throw_made += match.free_throw_made
    	three_point_attempt += match.three_point_attempt
    	three_point_made += match.three_point_made
    	rebounds_defense += match.rebounds_defense
    	rebounds_offense += match.rebounds_offense 
    	minutes_played += match.minutes_played
    	assists += match.assists
    	steals += match.steals 
    	blocks += match.blocks
    	turnovers += match.turnovers
    	personal_fouls += match.personal_fouls
    	started += 1 if match.started      
    end 
    
    # update scorecard with all calculations
      scorecard.update_attributes(:field_goal_attempt => field_goal_attempt, :field_goal_made => field_goal_made,
                	                :free_throw_attempt => free_throw_attempt, :free_throw_made => free_throw_made,
                                	:three_point_attempt => three_point_attempt, :three_point_made => three_point_made, 
                                	:rebounds_defense => rebounds_defense, :rebounds_offense => rebounds_offense, 
                                	:minutes_played => minutes_played, :assists => assists, :steals => steals, :blocks => blocks, 
                                	:turnovers => turnovers, :personal_fouls => personal_fouls, :started => started)
  end
  
  def self.update_group_user_ranking(group, previous_matches=true)
    # default variables
    first, ranking, past_points, last = 0, 0, 0, 0

    # ranking
    unless previous_matches
      @scorecards = Scorecard.find(:all, :joins => "LEFT JOIN users on users.id = scorecards.user_id",
                        :conditions =>["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false", group.id], 
                        :order => 'points desc, users.name')
      
    # previous ranking
    else
      @scorecards = Scorecard.find(:all, :joins => "LEFT JOIN users on users.id = scorecards.user_id",
                      :conditions =>["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false", group.id], 
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
  def self.set_archive_flag(user, group, flag)
    @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user.id, group.id])
    @scorecard.update_attribute(:archive, flag)
    self.calculate_group_scorecard(group)
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
    find(:first, 
    :conditions => ["user_id = ? and group_id = ? and archive = ?", user.id, group.id, false]).nil?
  end
  
  def self.archive?
    return self.archive
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
                            (100 * scorecards.played / #{played_games}) as coeficient_played",
                :joins => "LEFT JOIN groups on groups.id = scorecards.group_id
                         LEFT JOIN users on users.id = scorecards.user_id 
                         LEFT JOIN matches on matches.user_id = scorecards.user_id",
                :conditions => ["scorecards.group_id = ? and scorecards.user_id > 0 and scorecards.played > 0 and scorecards.archive = false 
                               and matches.schedule_id = ? and matches.archive = false", group, the_schedules.first.id],
                :order => the_sort)
    else
      return nil
    end
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
