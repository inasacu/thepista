# to run:    sudo rake the_game_score

desc "create games based on cup teams and groups..."
task :the_game_score => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @cup = Cup.find(:first)

  counter = 0
  @games = Game.find(:all, :conditions => ["cup_id = ? and played = false and type_name = 'GroupStage'", @cup])
  @games.each do |game|  
    # game.next_game_id = game.id
    game.home_score = 1 + rand(6)
    game.away_score = 1 + rand(6)
    game.away_score = counter if counter > 5
    game.save!  
    counter = 0 if counter > 5
  end

end









