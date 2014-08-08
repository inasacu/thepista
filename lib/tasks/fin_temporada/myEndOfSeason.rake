# to run:    heroku run rake db:migrate --app zurb
# to
# to run:    heroku run rake final_temporada_borrar_archive --app zurb
# to run:    heroku run rake myEndOfSeason --app zurb

desc "ARCHIVE all records related to group then reset group archive to false"
task :myEndOfSeason => :environment do |t|


	# archive group 
	the_datas = []
	counter = 1

  # ALL CODE BLOCKED...ONLY RUN IN AUGUST


  # # CASTS
  #   Cast.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # CHALLENGES
  # Challenge.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # CHALLENGES_USERS
  # ChallengesUsers.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # CUPS
  # Cup.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # CUPS_ESCUADRAS
  # CupsEscuadras.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # ESCUADRAS
  # Escuadra.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # FEES
  # Fee.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # GAMES
  # Game.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # MATCHES
  # Match.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # PAYMENTS
  # Payment.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # SCHEDULES
  # Schedule.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  # 
  # # STANDINGS
  # Standing.find(:all).each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  #   
  # # SCORECARDS
  # Scorecard.find(:all, :conditions => "group_id not in (select id from groups)").each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  #   
  #   Scorecard.find(:all, :conditions => "archive = true").each do |the_data|
  #     puts " (#{counter}). #{the_data.class.to_s}: #{the_data.id} archived files REMOVED"
  #     the_data.destroy
  #     counter += 1
  #   end
  #   
  #   Scorecard.find(:all).each do |the_data|
  #     the_data.wins                = 0
  #     the_data.draws               = 0
  #     the_data.losses              = 0
  #     the_data.points              = 0.0
  #     the_data.ranking             = 0
  #     the_data.played              = 0
  #     the_data.assigned            = 0
  #     the_data.goals_for           = 0
  #     the_data.goals_against       = 0
  #     the_data.goals_scored        = 0
  #     the_data.previous_points     = 0
  #     the_data.previous_ranking    = 0
  #     the_data.previous_played     = 0
  #     the_data.payed               = 0
  #     the_data.save!
  #   end

	
	
end

