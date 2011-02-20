# to run:    sudo rake the_pista_trueskill

require 'rubygems'
require 'saulabs/trueskill'

include Saulabs::TrueSkill

desc "  # use the trueskill ranking system for players"
task :the_pista_trueskill => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  the_group = Group.find(9)
  
  
  # set all records in match
  all_user_matches = Match.find(:all, :conditions => ["archive = false and schedule_id in (select id from schedules where schedules.group_id = ?)", the_group])
  all_user_matches.each do |match|
    match.mean_skill = 0.0
    match.skill_deviation = 0.0
    match.game_number = 0
    match.save!
    # puts "reset match_id:  #{match.id}"
  end
  
  # # set all matches where user has played to corresponding correct game number played per player
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
        
    if game_number != match.game_number
      match.mean_skill = 0.0
      match.skill_deviation = 0.0
      match.game_number = game_number
      match.save!
      # puts "reset user:  #{match.user_id} - #{game_number}"
    end
    
  end
  
  home_rating = []
  away_rating = []
  the_match_home = []  
  game_number  = 1
  
  the_schedules_played = Schedule.find(:all, :conditions => ["group_id = ? and played = true and archive = false", the_group], :order => "starts_at")
  the_schedules_played.each do |schedule|
    
    # schedule_number = Schedule.count(:conditions => ["group_id = ? and played = true and archive = false and starts_at < 
    #                                       (select starts_at from schedules where group_id = ? and played = true and schedules.id = ?)", the_group, the_group, schedule])
    
    schedule_number = Schedule.schedule_number(schedule)    
    # puts "_____________________________________"                                 
    # puts "#{schedule_number}"   
    # puts "_____________________________________"    
    
    # puts "#{schedule.concept}"
        
    the_match_home = []
    home_score, away_score = 0, 0
    
  
    the_matches = Match.find(:all, :select => "matches.*",
                      :joins => "left join schedules on schedules.id = matches.schedule_id",
                      :conditions => ["schedules.id = ? and schedules.played = true and matches.type_id = 1 and schedules.archive = false and matches.archive = false", schedule],
                      :order => "matches.group_id DESC")
                    
    the_matches.each do |match|
  
      is_second_team = !(match.group_id > 0)    
      home_score, away_score = match.group_score, match.invite_score
  
      mean_skill = MEAN_SKILL
      skill_deviation = SKILL_DEVIATION
      game_number = 1
    
      # get users previous games skill levels
      if schedule_number > 1
        # previous_user_match = Match.find(:first, :select => "matches.mean_skill, matches.skill_deviation, matches.game_number, matches.user_id, matches.id", 
        #                                              :conditions => ["user_id = ? and type_id = 1 and game_number > 0 and game_number < ?", match.user_id, schedule_number],
        #                                              :order => "game_number DESC")
        
        previous_user_match = Match.get_previous_user_match(match, schedule_number) 
  
        unless previous_user_match.nil? 
          if  previous_user_match.game_number > 0
            mean_skill = previous_user_match.mean_skill unless previous_user_match.mean_skill.to_f == 0.0
            skill_deviation = previous_user_match.skill_deviation unless previous_user_match.skill_deviation.to_f == 0.0
            game_number  = previous_user_match.game_number
          end
        end
      end
        
      play_activity = game_number / schedule_number
  
      # puts " #{match.user_id} - μ = #{mean_skill} σ = #{skill_deviation}, #{play_activity} = #{game_number} / #{schedule_number}"
  
      if is_second_team
        away_rating << Rating.new(mean_skill, skill_deviation, play_activity) 
      else
        home_rating << Rating.new(mean_skill, skill_deviation, play_activity)
      end  
      the_match_home << match
  
    end
  
    the_first, the_second = 1, 2  if (home_score.to_i > away_score.to_i)
    the_first, the_second = 1, 1 if (home_score.to_i == away_score.to_i)
    the_first, the_second = 2, 1 if (home_score.to_i < away_score.to_i)
  
    graph = FactorGraph.new([home_rating, away_rating], [the_first, the_second])
    graph.update_skills
  
    index = -1
    graph.teams.each do |teams|
      # puts "__________________________________________"
     
      teams.each do |player|  
        # puts "user:  #{the_match_home[index].user_id} #{player.mean} #{player.deviation}"
     
        the_match_home[index].mean_skill = player.mean
        the_match_home[index].skill_deviation = player.deviation
        the_match_home[index].save
        index +=1
     
      end
     
    end
    
  end
  
  
  # # display all user results
  user_true_skill = []
  the_user = []
    
  the_group.users.each do |user|   
    unless the_user.include?(user)
      user_true_skill << Match.get_user_group_skill(user, the_group) 
      the_user << user
    end
  end
  
  puts "---------CURRENT PLAYER SKILL SET ----------"  
  user_true_skill.each do |match| 
    puts "#{match.user_id}:  #{match.mean_skill} / #{match.skill_deviation} <> #{match.game_number}"
    # puts "CSE = μ - k*σ"
    CSE = match.mean_skill - (K_FACTOR * match.skill_deviation)
    puts "SKILL:  #{K_FACTOR * match.skill_deviation}"
    puts "#{sprintf( "%.0f", CSE * 10)}"
    puts "_________________________________________"
  end
  
end