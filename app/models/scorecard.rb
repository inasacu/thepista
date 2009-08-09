class Scorecard < ActiveRecord::Base 

  # include ActivityLogger
  # 
  # # Authorization plugin
  # acts_as_authorizable 
  # acts_as_paranoid
  # 
  belongs_to :user
  belongs_to :group
  # 
  # ## recalculate group scorecard
  # def self.recalculate_group_scorecard(group)
  # 
  #   @scorecards = Scorecard.find(:all, :conditions =>["group_id = ? and user_id > 0 and archive = ?", group, false])    
  #   if group.schedules.count > 0
  #     @last_schedule = Schedule.max(group.schedules.first)
  # 
  #     @scorecards.each do |scorecard|      
  #       # default variables      
  #       wins, losses, draws, played, assigned, goals_for, goals_against, goals_scored = 0, 0, 0, 0, 0, 0, 0, 0
  #       prev_wins, prev_losses, prev_draws, prev_played = 0, 0, 0, 0
  # 
  #       Match.find_user_group_matches(scorecard.user_id, scorecard.group_id).each do |match|
  #         if (match.one_x_two == 'X')
  #           draws += 1
  #           prev_draws = 1 if (match.schedule_id == @last_schedule.id)
  #         else
  #           wins += 1 if match.one_x_two == match.user_x_two                  
  #           losses += 1 if match.one_x_two != match.user_x_two
  # 
  #           if (match.schedule_id == @last_schedule.id)
  #             prev_wins = 1 if match.one_x_two == match.user_x_two          
  #             prev_losses = 1 if match.one_x_two != match.user_x_two 
  #           end
  #         end
  #         if match.played
  #           played += 1
  #           prev_played = 1 if (match.schedule_id == @last_schedule.id)
  # 
  #           case match.user_x_two
  #           when "1"
  #             # puts "#{scorecard.user.name } goals for #{match.group_score.to_i}"
  #             goals_for += match.group_score.to_i
  #             goals_against += match.invite_score.to_i
  #           when "X"
  #             # puts "#{scorecard.user.name } goals tied #{match.group_score.to_i}"
  #             goals_for += match.group_score.to_i
  #             goals_against += match.group_score.to_i
  #           when "2"
  #             # puts "#{scorecard.user.name } goals for #{match.invite_score.to_i}"
  #             goals_for += match.invite_score.to_i
  #             goals_against += match.group_score.to_i 
  #           end
  # 
  #         end        
  #         first = false
  #       end 
  #       
  #       assigned = Match.user_assigned(scorecard).total
  #       goals_scored = Match.user_goals_scored(scorecard).total
  #       
  #       assigned ||= 0
  #       goals_scored ||= 0
  #       
  #       # ticker all the results for the user, group conbination and points relate to team activity
  #       scorecard.update_attribute(:wins, wins)
  #       scorecard.update_attribute(:losses, losses)
  #       scorecard.update_attribute(:draws, draws)
  #       scorecard.update_attribute(:played, played)
  #       scorecard.update_attribute(:points, (wins * scorecard.group.points_for_win) + 
  #       (draws * scorecard.group.points_for_draw) + 
  #       (losses * scorecard.group.points_for_lose))           
  # 
  #       scorecard.update_attribute(:previous_played, played-prev_played)
  #       scorecard.update_attribute(:previous_points, (wins-prev_wins * scorecard.group.points_for_win) +
  #       (draws-prev_draws * scorecard.group.points_for_draw) + 
  #       (losses-prev_losses * scorecard.group.points_for_lose))   
  # 
  # 
  #       scorecard.update_attribute(:goals_for, goals_for)
  #       scorecard.update_attribute(:goals_against, goals_against)
  #       scorecard.update_attribute(:assigned, assigned)
  #       scorecard.update_attribute(:goals_scored, goals_scored)
  #     end
  #   end
  #   
  # end
  # 
  # # update user scorecard based on match and schedule
  # def self.update_group_scorecard(schedule)
  # 
  #   # this code was causing new user not to showup on scoreboard
  #   # @scorecards = Scorecard.find(:all, :conditions =>["group_id = ? and user_id > 0 and played > 0", schedule.group])
  #   @scorecards = Scorecard.find(:all, :conditions =>["group_id = ? and user_id > 0", schedule.group])
  #   @last_schedule = Schedule.max(schedule)
  #   
  #   @scorecards.each do |scorecard|
  #     # default variables      
  #     wins, losses, draws, played, assigned = 0, 0, 0, 0, 0
  #     prev_wins, prev_losses, prev_draws, prev_played = 0, 0, 0, 0
  # 
  #     Match.find_user_group_matches(scorecard.user_id, scorecard.group_id).each do |match|
  #       if (match.one_x_two == 'X')
  #         draws += 1
  #         prev_draws = 1 if (match.schedule_id == @last_schedule.id)
  #       else
  #         wins += 1 if match.one_x_two == match.user_x_two                  
  #         losses += 1 if match.one_x_two != match.user_x_two
  # 
  #         if (match.schedule_id == @last_schedule.id)
  #           prev_wins = 1 if match.one_x_two == match.user_x_two          
  #           prev_losses = 1 if match.one_x_two != match.user_x_two 
  #         end
  #       end
  #       if match.played
  #         played += 1
  #         prev_played = 1 if (match.schedule_id == @last_schedule.id)
  #       end        
  #       first = false
  #     end 
  # 
  #     # ticker all the results for the user, group conbination and points relate to team activity
  #     scorecard.update_attribute(:wins, wins)
  #     scorecard.update_attribute(:losses, losses)
  #     scorecard.update_attribute(:draws, draws)
  #     scorecard.update_attribute(:played, played)
  #     scorecard.update_attribute(:points, (wins * scorecard.group.points_for_win) + 
  #                                         (draws * scorecard.group.points_for_draw) + 
  #                                         (losses * scorecard.group.points_for_lose))           
  #                                               
  #     scorecard.update_attribute(:previous_played, played-prev_played)
  #     scorecard.update_attribute(:previous_points, (wins-prev_wins * scorecard.group.points_for_win) +
  #                                                  (draws-prev_draws * scorecard.group.points_for_draw) + 
  #                                                  (losses-prev_losses * scorecard.group.points_for_lose))   
  #     
  #    scorecard.update_attribute(:assigned, Match.user_assigned(scorecard).total)
  #    scorecard.update_attribute(:goals_scored, Match.user_goals_scored(scorecard).total)
  #   end
  # end
  # 
  # def self.update_group_ranking(schedule)
  #   # ranking
  #   first, ranking, past_points, last = 0, 0, 0, 0
  # 
  #   @scorecards = Scorecard.find(:all, 
  #                                :conditions =>["group_id = ? and user_id > 0 and played > 0 and archive = false", schedule.group], 
  #                                :order => 'points desc, (scorecards.points / (scorecards.played * 3)) desc')
  # 
  #   @scorecards.each do |scorecard| 
  #       if first != scorecard.group_id 
  #         first, ranking, past_points, last = scorecard.group_id, 0, 0, 1
  #       end 
  # 
  #       if (past_points == scorecard.points) 
  #         last += 1          
  #       else
  #         ranking += last
  #         last = 1          
  #       end
  #       past_points = scorecard.points         
  #     
  #     scorecard.update_attribute(:ranking, ranking)
  #   end
  # 
  #   # previous ranking
  #   first, ranking, past_points, last = 0, 0, 0, 0
  # 
  #   @scorecards = Scorecard.find(:all, 
  #                                :conditions =>["group_id = ? and user_id > 0 and played > 0 and archive = false", schedule.group], 
  #                                :order => 'previous_points desc, (scorecards.previous_points / (scorecards.previous_played * 3)) desc')
  # 
  #   @scorecards.each do |scorecard| 
  # 
  #       if first != scorecard.group_id 
  #         first, ranking, past_points, last = scorecard.group_id, 0, 0, 1
  #       end 
  # 
  #       if (past_points == scorecard.previous_points) 
  #         last += 1          
  #       else
  #         ranking += last
  #         last = 1          
  #       end
  #       past_points = scorecard.previous_points         
  #  
  #     scorecard.update_attribute(:assigned, Match.user_assigned(scorecard).total)
  #     scorecard.update_attribute(:goals_scored, Match.user_goals_scored(scorecard).total)
  #     scorecard.update_attribute(:previous_ranking, ranking)
  #   end
  # 
  # end
  # 
  # def self.set_user_group_scorecard(user, group)
  #   # win, lose, draw, played, assigned = 0, 0, 0, 0, 0
  #   wins, losses, draws, played, assigned = 0, 0, 0, 0, 0
  #   Match.find(:all, :conditions => ["user_id = ? and (group_id = ? or invite_id = ?)", user.id, group.id, group.id]).each do |score|
  #     if (score.type_id == 1 and score.played)  # user was in the game
  #       if (score.one_x_two == 'X')
  #         draws += 1
  #       else
  #         wins += 1 if score.one_x_two == score.user_x_two
  #         losses += 1 if score.one_x_two != score.user_x_two
  #       end
  #       played += 1 
  #       # assigned += 1
  #     end
  #   end
  # 
  #   #    ticker all the results for the user, group conbination and points relate to team activity
  #   @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user.id, group.id])
  #   @scorecard.update_attribute(:wins, wins)
  #   @scorecard.update_attribute(:losses, losses)
  #   @scorecard.update_attribute(:draws, draws)
  #   @scorecard.update_attribute(:played, played)
  # 
  #   @scorecard.update_attribute(:points, (wins * @scorecard.group.points_for_win) + 
  #                                       (draws * @scorecard.group.points_for_draw) + 
  #                                       (losses * @scorecard.group.points_for_lose)) 
  #                                       
  #   @scorecard.update_attribute(:assigned, Match.user_assigned(@scorecard).total) 
  #   @scorecard.update_attribute(:goals_scored, Match.user_goals_scored(@scorecard).total)
  # 
  # end
  # 
  # def self.set_archive_flag(user, group, flag)
  #   @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", user.id, group.id])
  #   @scorecard.update_attribute(:archive, flag)
  #   self.set_user_group_scorecard(user, group)
  # end
  # 
  # # update user scorecard based on match and schedule  
  # def self.remove_user_scorecard(schedule)
  #   wins, losses, draws, played, assigned = 0, 0, 0, 0, 0
  #   Match.find_by_schedule_id(schedule).each do |score|      
  #     if (score.one_x_two == 'X')
  #       draws -= 1
  #     else
  #       wins -= 1 if score.one_x_two == score.user_x_two
  #       losses -= 1 if score.one_x_two != score.user_x_two
  #     end
  #     played -= 1
  #   end
  # 
  #   @scorecard = Scorecard.find(:first, :conditions => ["user_id = ? and group_id = ?", match.user_id, schedule.group_id])
  #   @scorecard.update_attribute(:wins, wins)
  #   @scorecard.update_attribute(:losses, losses)
  #   @scorecard.update_attribute(:draws, draws)
  #   @scorecard.update_attribute(:played, played)
  # 
  #   @scorecard.update_attribute(:points, (wins * @scorecard.group.points_for_win) + 
  #                                       (draws * @scorecard.group.points_for_draw) + 
  #                                       (losses * @scorecard.group.points_for_lose))
  #                                       
  #   @scorecard.update_attribute(:assigned, Match.user_assigned(@scorecard).total)
  #   @scorecard.update_attribute(:goals_scored, Match.user_goals_scored(@scorecard).total)
  # end
  # 
  # # record if user and group dont exist
  # def self.create_user_scorecard(user, group)
  #   create(:group_id => group.id, :user_id => user.id) if self.exists?(user, group)
  # end  
  # 
  # # Return true if the match exist
  # def self.exists?(user, group)
  #   find_by_group_id_and_user_id(group, user).nil?
  # end
 
  end
