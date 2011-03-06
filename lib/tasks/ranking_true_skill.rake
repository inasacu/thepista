# to run: sudo rake ranking_true_skill

require 'rubygems'
require 'saulabs/trueskill'

include Saulabs::TrueSkill

desc "  # use the trueskill ranking system for players"
task :ranking_true_skill => :environment do |t|


  initial_mean = 25.0
  k_factor = 3
  initial_deviation = initial_mean / 3.0
  beta = initial_deviation / 2.0
  tau = initial_deviation / 100.0
  
  final_mean = 36.771
  final_deviation = 5.749
  true_skill = final_mean - (k_factor * final_deviation)
  
  puts "#{initial_mean} #{k_factor} #{initial_deviation} #{beta} #{tau} #{final_mean} #{final_deviation} #{true_skill}"

  # test values
  # Name      Outcome   Pre-Game μ  Pre-Game σ  Post-Game μ   Post-Game σ 
  # Alice     1st       25          8.3         36.771        5.749 
  # Bob       2nd       25          8.3         32.242        5.133 
  # Chris     3rd       25          8.3         29.074        4.943 
  # Darren    4th       25          8.3         26.322        4.874 
  # Eve       5th       25          8.3         23.678        4.874 
  # Fabien    6th       25          8.3         20.926        4.943 
  # George    7th       25          8.3         17.758        5.133 
  # Hillary   8th       25          8.3         13.229        5.749 

  # result values
  #   μ = 36.7184277917719        σ = 5.73097426909823
  #   μ = 32.2105160893272        σ = 5.11886147810659
  #   μ = 29.056240513133         σ = 4.93005006081811
  #   μ = 26.3164438701142        σ = 4.8623910162541
  #   μ = 23.6835561299701        σ = 4.86239101624522
  #   μ = 20.9437594869587        σ = 4.93005006079134
  #   μ = 17.789483910776         σ = 5.11886147806399
  #   μ = 13.2815722082744        σ = 5.73097426916592
  
  
  the_initial_mean = 25
  the_initial_deviation = 8.3
  play_activity = 1.0

  alice = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  bob = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  chris = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  darren = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  eve = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  fabien = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  george = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]
  hillary = [Rating.new(the_initial_mean, the_initial_deviation, play_activity)]

  graph = FactorGraph.new([alice, bob, chris, darren, eve, fabien, george, hillary], [1,2,3,4,5,6,7,8])
  graph.update_skills

  graph.teams.each do |teams|    
    teams.each do |player|  
      true_skill = player.mean - (3*player.deviation)
      true_skill = 0 if true_skill < 0
      
      beta = player.deviation / 2.0
      tau = player.deviation / 100.0
      
      true_skill = "#{sprintf( "%.0f", true_skill)}"
      beta = "#{sprintf( "%.3f", beta)}"
      tau = "#{sprintf( "%.3f", tau)}"
      
      
      puts "μ = #{player.mean} σ = #{player.deviation} true = #{true_skill} beta = #{beta} tau = #{tau}" 
    end     
  end

end