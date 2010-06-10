# to run:    sudo rake the_game_points

desc "add activity id to sport id on group, schedule and tournament...migration"
task :the_game_points => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # :points_for_single            => 0
  # :points_for_double            => 50
  # :points_for_winner            => 25
  # :points_for_draw              => 15
  # :points_for_goal_difference   => 10
  # :points_for_goal_total        => 5
  
  Game.find(:all).each do |game|
    game.points_for_single            = 0
    game.points_for_double            = 10
    game.points_for_winner            = 5
    game.points_for_draw              = 3
    game.points_for_goal_difference   = 2
    game.points_for_goal_total        = 1
    game.save!
    puts game.concept
  end

end
