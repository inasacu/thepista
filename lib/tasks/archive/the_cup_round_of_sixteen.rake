# to run:     rake the_cup_round_of_sixteen

desc "create games based on cup teams and groups..."
task :the_cup_round_of_sixteen => :environment do |t|
  
  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  
  @cup = Cup.find(5)
  
  # need to order teams that have qualified in ranking order since final stage game generator sets 1st w/ last team

  # 1A - 2B         1 - 8
  # 1C - 2D         2 - 7
  # 1B - 2A         3 - 6
  # 1D - 2C         4 - 5
  
  
  counter = 0
  @final_stage = []
  @final_stage << Escuadra.find_by_name('Czech Republic')
  @final_stage << Escuadra.find_by_name('Spain')
  @final_stage << Escuadra.find_by_name('Germany')
  @final_stage << Escuadra.find_by_name('England')
  @final_stage << Escuadra.find_by_name('Italy')
  @final_stage << Escuadra.find_by_name('Greece')
  @final_stage << Escuadra.find_by_name('France')
  @final_stage << Escuadra.find_by_name('Portugal')
  
  @final_stage.each {|the_escuadra| puts "#{counter +=1}:  #{the_escuadra.name} - #{the_escuadra.id}"}   
  @cup.create_final_stage(@final_stage) unless @final_stage.nil?
end









    