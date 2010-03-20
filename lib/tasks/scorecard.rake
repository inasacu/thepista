# to run:    sudo rake thescorecard

desc "fix all scorecards based on team points for win, lose and draw"
task :thescorecard => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  
  # ## add zero to goals scored as default
  # Match.find(:all).each do |match|
  #   match.goals_scored = 0
  #   match.save!
  # end
  
  ## set the points based on the wins, losses and draws...values depend on group point system...
  ## also assignes the number of games a player has listed as convocado
  # Scorecard.find(:all, :conditions => "user_id > 0 and archive = false").each do |scorecard|
  #   scorecard.points = (scorecard.wins * scorecard.group.points_for_win) + 
  #   (scorecard.losses * scorecard.group.points_for_lose) + 
  #   (scorecard.draws * scorecard.group.points_for_draw) 
  #       
  #   assigned = Match.user_assigned(scorecard).total
  #   goals_scored = Match.user_goals_scored(scorecard).total
  #   
  #   assigned ||= 0
  #   goals_scored ||= 0
  #       
  #   puts "#{scorecard.user.name } #{assigned} assigned games..."
  #   scorecard.assigned = assigned
  #   
  #   puts "#{scorecard.user.name } #{goals_scored} scored goals..."
  #   scorecard.goals_scored = goals_scored
  #   
  #   scorecard.save!
  # end
  # 
  # Group.find(:all).each do |group|
  # 
  #   # ranking
  #   first, ranking, past_points, last = 0, 0, 0, 0
  # 
  #   @scorecards = Scorecard.find(:all, 
  #                               :conditions =>["group_id = ? and user_id > 0 and played > 0 and archive = false", group], 
  #                               :order => 'points desc, (scorecards.points / (scorecards.played * 3)) desc')
  # 
  #   @scorecards.each do |scorecard| 
  #     if first != scorecard.group_id 
  #       first, ranking, past_points, last = scorecard.group_id, 0, 0, 1
  #     end 
  # 
  #     if (past_points == scorecard.points) 
  #       last += 1          
  #     else
  #       ranking += last
  #       last = 1          
  #     end
  #     past_points = scorecard.points         
  # 
  #     scorecard.ranking = ranking
  #     scorecard.save!
  #   end
  # 
  #   # previous ranking
  #   first, ranking, past_points, last = 0, 0, 0, 0
  # 
  #   @scorecards = Scorecard.find(:all, 
  #                               :conditions =>["group_id = ? and user_id > 0 and played > 0 and archive = false", group], 
  #                               :order => 'previous_points desc, (scorecards.previous_points / (scorecards.previous_played * 3)) desc')
  # 
  #   @scorecards.each do |scorecard| 
  # 
  #     if first != scorecard.group_id 
  #       first, ranking, past_points, last = scorecard.group_id, 0, 0, 1
  #     end 
  # 
  #     if (past_points == scorecard.previous_points) 
  #       last += 1          
  #     else
  #       ranking += last
  #       last = 1          
  #     end
  #     past_points = scorecard.previous_points         
  # 
  #     scorecard.previous_ranking = ranking
  #     scorecard.save!
  #     
  #   end
  # end
  # 
  # ## update group scorecard
  # Group.find(:all).each do |group|
  #   Scorecard.calculate_group_scorecard(group)
  # end

end

