# to run:     rake the_cup

desc "create games based on cup teams and groups..."
task :the_cup => :environment do |t|

  @cup = Cup.find(5)
  
  # # delete all games, rounds and standings in dbase
  # # @games = Game.find(:all, :conditions => ["cup_id = ? ", @cup.id])
  # # @games.each {|game| game.destroy}
  # 
  # 
  # # cup needs to have escuadras in order to setup all games
  # number_of_escuadras = 0
  # counter = 0
  # 
  # @groups_in_stage = []
  # Standing.create_cup_escuadra_standing(@cup)  
  # @standings = Standing.cup_escuadras_standing(@cup)
  # @standings.each {|standing| number_of_escuadras += 1}
  # 
  # default_group_stage = @standings.first.group_stage_name
  # 
  # # get groups from cup into an array
  # @standings.each do |standing|  
  #   counter += 1  
  #   if (default_group_stage == standing.group_stage_name)
  #     # puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}"
  #     @groups_in_stage << Escuadra.find(standing.item_id)
  #   end  
  #   if (default_group_stage != standing.group_stage_name or counter == number_of_escuadras)
  #     @cup.create_group_stage(@groups_in_stage) 
  #     @groups_in_stage = []
  #     default_group_stage = standing.group_stage_name
  #     @groups_in_stage << Escuadra.find(standing.item_id)  
  #     # puts "#{standing.group_stage_name} #{Escuadra.find(standing.item_id).name}" unless counter == number_of_escuadras
  #   end  
  # end
  
  # get top escuadras in groups from cup into an array
  @final_stage = []
  teams_per_group_advance = 2
  group_letter = 'Z'
  team_counter = 0
  counter = 0
  
  @standings = Standing.find(:all, 
                             :conditions => ["cup_id = ? and group_stage_name != 'Z' and item_type = 'Escuadra'", @cup.id], 
                             :order => 'group_stage_name, ranking')
  
  @standings.each do |standing|
    the_escuadra = Escuadra.find(standing.item_id)
    
    if group_letter != standing.group_stage_name
      group_letter = standing.group_stage_name
      team_counter = 1
    else
      team_counter +=1
    end
    
    if team_counter <= teams_per_group_advance and 
      @final_stage << the_escuadra
      puts "#{counter +=1}:  #{the_escuadra.name} - #{the_escuadra.id}"
    end
        
  end   
  @cup.create_final_stage(@final_stage) unless @final_stage.nil?
    
  # use stage table to create last stage
  # @cup.remove_subesequent_games
  
  
  
  # create rounds for all users
  # @cup.challenges.each {|challenge| Cast.create_challenge_cast(challenge)}  
end









