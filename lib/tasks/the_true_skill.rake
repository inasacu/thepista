# to run:    sudo rake the_true_skill

 require 'rubygems'
 require 'saulabs/trueskill'

 include Saulabs::TrueSkill

desc "  # the true skill"
task :the_true_skill => :environment do |t|

  # team 1 has just one player with a :
  # mean skill of 27.1, 
  # a skill-deviation of 2.13
  # and an play activity of 100 %
  
  mean_skill = 27.1
  skill_deviation = 2.13
  play_activity = 100 / 100
  
  # team1 = [Rating.new(27.1, 2.13, 1.0)]
  the_rating1 = Rating.new(mean_skill, skill_deviation, play_activity)
  puts the_rating1.activity
  puts the_rating1.tau
  puts the_rating1.tau_squared
  
  # team1 = [Rating.new(mean_skill, skill_deviation, play_activity)]
  team1 = [the_rating1]
  puts "team1:  #{team1}"

  # team 2 has two players
  team2 = [Rating.new(22.0, 0.98, 0.8), Rating.new(31.1, 5.33, 0.9)]
  puts "team2:  #{team2}"
        
  # team 1 finished first and team 2 second
  graph = FactorGraph.new([team2, team1], [1,2])

  # puts "before"
  # puts graph  
  
  # update the Ratings
  graph.update_skills
  puts "graph.beta:  #{graph.beta}"
  puts "graph.beta_squared:  #{graph.beta_squared}"
  puts "graph.epsilon:  #{graph.epsilon}"
  puts "graph.teams:  "
  puts graph.teams
  
  # puts "graph.layers:"
  # puts graph.layers  
  # puts "before"
  # puts graph
  # puts graph.draw_margin
  # puts "after"
  # puts graph  
  # puts graph.layers
  # puts graph.draw_probability  
  
end
