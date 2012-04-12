# to run: sudo rake the_true_skill


require 'rubygems'
# require 'saulabs/trueskill'

# include Saulabs::TrueSkill

desc "  # use the trueskill ranking system for players"
task :the_true_skill => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  the_group = Group.find(9)

  InitialMean = 25
  Initial_Factor = 3
  
  # InitialMean = 120
  # Initial_Factor = 4   
  # Beta = 200
  # DynamicsFactor/Tau= 4
  # Draw Probability = 0.04

  the_initial_standard_deviation = (InitialMean / Initial_Factor).to_f
  # the_beta = (the_initial_standard_deviation / 2).to_f 
  # the_tau = (the_initial_standard_deviation / 100).to_f
  # the_true_skill = (InitialMean - (K_FACTOR * the_initial_standard_deviation)).to_f
  
  # set all records in match related to team 
  sql = %(UPDATE matches set initial_mean = 0.0, initial_deviation = 0.0, final_mean = 0.0, final_deviation = 0.0, game_number = 0
           where archive = false and schedule_id in (select id from schedules where schedules.played = true and schedules.group_id = #{the_group.id}))
  ActiveRecord::Base.connection.execute(sql)
  
  
  # set all matches where user has played to corresponding correct game number played per player
  all_user_played_matches = Match.find(:all, :select => "matches.*",
  :joins => "left join schedules on schedules.id = matches.schedule_id",
  :conditions => ["schedules.group_id = ? and schedules.played = true and matches.type_id = 1 and schedules.archive = false and matches.archive = false", the_group],
  :order => "matches.user_id, schedules.starts_at")
  user_id = 0
  game_number = 0
  
  all_user_played_matches.each do |match|  
    unless user_id == match.user_id
      user_id = match.user_id
      game_number = 0
    end  
    game_number += 1
  
    if game_number != match.game_number or game_number.nil?
      if game_number == 1
        match.initial_mean = InitialMean
        match.initial_deviation = the_initial_standard_deviation
        match.game_number = game_number
        match.save!
      else
        match.initial_mean = 0
        match.initial_deviation = 0
        match.game_number = game_number
        match.save!
      end
    end  
  end
  
    
  home_rating = []
  away_rating = []
  the_match_home = []  
  home_match = []
  away_match = []
  
  home_total = 0
  away_total = 0
  
  the_schedules_played = Schedule.find(:all, :conditions => ["group_id = ? and played = true and archive = false", the_group], :order => "starts_at")
  the_schedules_played.each do |schedule|
  
    # schedule = the_group.schedules.first
    
    home_score, away_score = 0, 0
    play_activity = 0.0
  
    schedule_number = Schedule.schedule_number(schedule)   
    puts "event #{schedule_number} = [ #{schedule.id} ] #{schedule.name}" 
  
    the_matches = Match.find(:all, :select => "matches.*",
    :joins => "left join schedules on schedules.id = matches.schedule_id",
    :conditions => ["schedules.id = ? and schedules.played = true and matches.type_id = 1 and schedules.archive = false and matches.archive = false", schedule],
    :order => "matches.group_id DESC")
  
    the_matches.each do |match|
  
      previous_final_mean = InitialMean
      previous_final_deviation = the_initial_standard_deviation
      
      mean_skill = InitialMean
      skill_deviation = the_initial_standard_deviation
  
      is_second_team = !(match.group_id > 0)    
      home_score, away_score = match.group_score, match.invite_score
      game_number = 1
  
      # get users previous games skill levels
      if schedule_number > 1
        previous_user_match = Match.get_previous_user_match(match, schedule_number, the_group) 
        unless previous_user_match.nil?
  
          if  previous_user_match.game_number > 0 and previous_user_match.final_deviation > 0.0                    
            mean_skill = previous_user_match.final_mean 
            skill_deviation = previous_user_match.final_deviation            
          end          
          game_number  = previous_user_match.game_number
        end        
        # puts "** #{previous_user_match.game_number} [#{previous_user_match.user_id}] #{previous_user_match.final_mean} #{previous_user_match.final_deviation} **"
      end      
      # puts "@@ [#{match.user_id}] - μ = #{mean_skill} σ = #{skill_deviation}, play_activity: #{play_activity} = #{game_number.to_f} / #{schedule_number.to_f} @@"
  
      play_activity = game_number.to_f / schedule_number.to_f     
  
      if is_second_team
        away_rating << Rating.new(mean_skill, skill_deviation, play_activity) 
        away_match << match
      else
        home_rating << Rating.new(mean_skill, skill_deviation, play_activity) 
        home_match << match
      end        
    end
    
    if (home_score.to_i > away_score.to_i)
      # puts "home_rating"
      home_match.each {|home| the_match_home << home}
      away_match.each {|away| the_match_home << away}
    elsif (home_score.to_i < away_score.to_i)
      # puts "away_rating"
      away_match.each {|away| the_match_home << away}
      home_match.each {|home| the_match_home << home}
    else 
      # puts "a tie" 
      home_match.each {|home| the_match_home << home}
      away_match.each {|away| the_match_home << away}
    end
  
    the_first, the_second = 1, 2 
    the_first, the_second = 1, 1  if (home_score.to_i == away_score.to_i)
  
    graph = FactorGraph.new([home_rating, away_rating], [the_first, the_second]) unless (home_score.to_i < away_score.to_i)
    graph = FactorGraph.new([away_rating, home_rating], [the_first, the_second]) if (home_score.to_i < away_score.to_i)
    graph.update_skills
  
    jornada = 0
    index = 0
    graph.teams.each do |teams|
      puts "Game: #{schedule_number} Score:  #{home_score} - #{away_score} "     
      teams.each do |player|  
        # puts "user:  #{the_match_home[index].user_id} μ = #{player.mean} σ = #{player.deviation}, index = #{index}"
        # puts "μ = #{player.mean} σ = #{player.deviation}, index = #{index}" 
  
        the_match_home[index].final_mean = player.mean
        the_match_home[index].final_deviation = player.deviation
        the_match_home[index].save 
        
        if the_match_home[index].game_number > 1                  
          the_previous_user_match = Match.get_previous_user_match(the_match_home[index], the_match_home[index].game_number, the_group)
          
          unless the_previous_user_match.nil?            
            # puts "previous match:  #{the_match_home[index].id} [ #{the_match_home[index].user_id} ] #{the_previous_user_match.final_mean} #{the_previous_user_match.final_deviation}"
            the_match_home[index].initial_mean = the_previous_user_match.final_mean 
            the_match_home[index].initial_deviation = the_previous_user_match.final_deviation 
            the_match_home[index].save
            # puts "match:  #{the_match_home[index].id} [ #{the_match_home[index].user_id} ]  #{the_match_home[index].initial_mean} #{the_match_home[index].initial_deviation} #{the_match_home[index].final_mean} #{the_match_home[index].final_deviation}"
          end
        
        end

          first_mean = "#{sprintf( "%.3f", the_match_home[index].initial_mean)}"
          last_mean = "#{sprintf( "%.3f", the_match_home[index].final_mean)}"

          first_deviation = "#{sprintf( "%.3f", the_match_home[index].initial_deviation)}"
          last_deviation = "#{sprintf( "%.3f", the_match_home[index].final_deviation)}"
          
          true_skill = the_match_home[index].final_mean - (K_FACTOR*the_match_home[index].final_deviation)
          true_skill = 0 if true_skill < 0

          true_skill = "#{sprintf( "%.0f", true_skill)}"
          
        puts "user: [ #{the_match_home[index].user_id} ] #{first_mean} => #{last_mean}, #{first_deviation} => #{last_deviation},  #{true_skill}"
               
        index +=1     
      end     
    end
  
    home_rating.clear
    away_rating.clear
    the_match_home.clear
    home_match.clear
    away_match.clear
  
  end

  # display all user results
  user_true_skill = []
  the_user = []
  
  the_group.users.each do |user|   
    unless the_user.include?(user)
      user_true_skill << Match.get_user_group_skill(user, the_group) 
      the_user << user
    end
  end
  
  # puts "---------CURRENT PLAYER SKILL SET ----------"  
  user_true_skill.each do |match| 
    InitialMean = match.initial_mean
    the_initial_standard_deviation = InitialMean / 3
    the_beta = the_initial_standard_deviation / 2 
    the_tau = the_initial_standard_deviation / 100
    the_true_skill = InitialMean - 3 * the_initial_standard_deviation
  
    # puts "#{match.user_id}:  #{InitialMean} #{the_initial_standard_deviation} / #{match.initial_deviation}] #{the_beta} LEVEL: #{the_true_skill}"
    # puts "#{match.user_id}:  #{match.initial_mean} #{match.initial_deviation} #{match.final_mean} #{match.final_deviation} "
    # puts "-----------------------------------------------"  
  end

end