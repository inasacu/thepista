# to run:    sudo rake the_cup

desc "create games based on cup teams and groups..."
task :the_cup => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @cup = Cup.find(:first)
  
  # delete all games, rounds and standings in dbase
  @games = Game.find(:all, :conditions => ["cup_id = ? ", @cup.id])
  @games.each {|game| game.destroy}

  number_of_escuadras = 0
  @groups_in_stage = []

  @standings = Standing.cup_escuadras_standing(@cup)

  @standings.each {|standing| number_of_escuadras += 1}

  counter = 0
  default_group_stage = @standings.first.group_stage_name

  # get groups from cup into an array
  @standings.each do |standing|
    
    counter += 1
    
    if (default_group_stage == standing.group_stage_name)
      puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}"
      @groups_in_stage << Escuadra.find(standing.item_id)
    end

    if (default_group_stage != standing.group_stage_name or counter == number_of_escuadras)
      puts ""
      @cup.create_group_stage(@groups_in_stage) 
      @groups_in_stage = []
      default_group_stage = standing.group_stage_name
      @groups_in_stage << Escuadra.find(standing.item_id)
 
      puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}" unless counter == number_of_escuadras
    end

  end



  # # final stage, get top players and create final stage
  # @final_round = Round.create!(:cup_id => @cup.id, :jornada => 2)  
  # @final_stage = Standing.find(:all, :conditions => ["round_id = ?", @group_stage_round], :order => 'ranking', :limit => (@number_of_escuadras/2).round)
  # 
  # unless @final_stage.nil?
  #   @second_wave = []
  #   @final_stage.each  do |wave|  
  #     @second_wave << wave.user
  #   end
  # 
  #   @cup.create_final_stage @second_wave 
  #   # @cup.create_final_stage @second_wave unless @cup.final_round_single
  # end
end









