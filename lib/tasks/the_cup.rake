# to run:    sudo rake the_cup

desc "create games based on cup teams and groups..."
task :the_cup => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @cup = Cup.find(:first)

  # delete all games, rounds and standings in dbase
  @games = Game.find(:all, :conditions => ["cup_id = ? ", @cup.id])
  @games.each {|game| game.destroy}

  number_of_escuadras = 0
  counter = 0

  @groups_in_stage = []
  Standing.create_cup_escuadra_standing(@cup)  
  @standings = Standing.cup_escuadras_standing(@cup)
  @standings.each {|standing| number_of_escuadras += 1}

  default_group_stage = @standings.first.group_stage_name

  # get groups from cup into an array
  @standings.each do |standing|  
    counter += 1  
    if (default_group_stage == standing.group_stage_name)
      # puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}"
      @groups_in_stage << Escuadra.find(standing.item_id)
    end  
    if (default_group_stage != standing.group_stage_name or counter == number_of_escuadras)
      @cup.create_group_stage(@groups_in_stage) 
      @groups_in_stage = []
      default_group_stage = standing.group_stage_name
      @groups_in_stage << Escuadra.find(standing.item_id)  
      # puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}" unless counter == number_of_escuadras
    end  
  end

  counter = 0
  @games = Game.find(:all, :conditions => ["cup_id = ? and played is false and type_name = 'GroupStage'", @cup])
  @games.each do |game|  
    # game.next_game_id = game.id
    game.home_score = 1 + rand(6)
    game.away_score = 1 + rand(6)
    game.away_score = counter if counter > 5
    game.save!  
    counter = 0 if counter > 5
  end

  # get top escuadras en groups from cup into an array
  @final_stage = []
  @standings = Standing.find(:all, :conditions => ["cup_id = ? and ranking <= ?", @cup.id, @cup.group_stage_advance])
  @standings.each do |standing|
    @final_stage << Escuadra.find(standing.item_id)
  end   

  
  @cup.create_final_stage(@final_stage) unless @final_stage.nil?
    
  # use stage table to create last stage
  @cup.remove_subesequent_games
    
end









