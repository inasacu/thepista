# to run:    rake the_archive_cup

desc "archive cups with few casts"
task :the_archive_cup => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  # archive flag
  has_to_archive = true

  # archive all challenges and cast w/ cup archived
  # @cups = Cup.find(:all, :conditions => "archive = true and official = true")
  # @cups.each do |cup|
  # 
  #   # puts "cup: #{cup.name}"
  # 
  #   final_played ||= false
  #   the_game = Game.final_game(cup)
  #   final_played = the_game.played unless (the_game.nil? or the_game.blank?)
  # 
  #   number_of_games = Game.find(:first, :select => "count(*) as total", :conditions => ["cup_id = ?", cup]).total
  # 
  # 
  #   @challenges = Challenge.find(:all, :conditions => ["cup_id = ? and archive = false", cup])
  #   @challenges.each do |challenge|
  # 
  #     total_cast = Cast.find(:first, :select => "count(*) as total", :conditions => ["challenge_id = ?", challenge]).total
  #     total_null_cast = Cast.find(:first, :select => "count(*) as total", 
  #     :conditions => ["challenge_id = ? and home_score is null and away_score is null", challenge]).total
  # 
  #     if (total_cast.to_i == total_null_cast.to_i)
  # 
  #       # archive challenge
  #       if has_to_archive
  # 
  #         puts "cup: #{cup.name}"
  #         puts "number_of_games: #{number_of_games.to_i}"
  #         puts "number_of_games: #{number_of_games.to_i}"
  #         puts "challenge: #{challenge.name}"
  #         puts "total_cast: #{total_cast.to_i}"
  #         puts "total_null_cast: #{total_null_cast.to_i}"
  # 
  #         challenge.archive = true
  #         challenge.save
  #       end
  # 
  #     end
  # 
  #   end
  # 
  # end
  
  @challenges = Challenge.find(:all, :conditions => "archive = false and cup_id in (select id from cups where archive = true)")
  @challenges.each do |challenge|
    
    puts "challenge/cup:  #{challenge.name}, #{challenge.cup_id}"
    challenge.archive = true
    challenge.save
    
  end
  
  @casts = Cast.find(:all, :conditions => "archive = false and challenge_id in (select id from challenges where archive = true)")
  @casts.each do |cast|
    
    puts "challenge/user:  #{cast.challenge_id}, #{cast.user_id}"
    cast.archive = true
    cast.save
    
  end

end
