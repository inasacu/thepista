# to run:    sudo rake the_archive_challenge

desc "archive challenges and cast"
task :the_archive_challenge => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # archive all challenges and cast for cups archived
  @cups = Cup.find(:all, :conditions => "archive = true")
  @cups.each do |cup|
    @challenges = Challenge.find(:all, :conditions => ["cup_id = ?", cup])
    @challenges.each do |challenge|
      
      # archive the challenge
      challenge.archive = true
      challenge.save!
      
      puts "archived challenge:  #{challenge.id}"
      
      # archive the casts for the challenge
      @casts = Cast.find(:all, :conditions => ["challenge_id = ?", challenge])
      @casts.each do |cast|
        cast.archive = true
        cast.save!
        
        puts "archived cast:  #{cast.id}"
        
      end
      
    end
  end
  

  # archive all chanllenges and cast w/ 
  @cups = Cup.find(:all, :conditions => "archive = false and official = true")
  @cups.each do |cup|

    # puts "cup: #{cup.name}"

    final_played ||= false
    the_game = Game.final_game(cup)
    final_played = the_game.played unless (the_game.nil? or the_game.blank?)

    number_of_games = Game.find(:first, :select => "count(*) as total", :conditions => ["cup_id = ?", cup]).total
    # puts "number_of_games: #{number_of_games.to_i}"

    @challenges = Challenge.find(:all, :conditions => ["cup_id = ?", cup])
    @challenges.each do |challenge|

      total_cast = Cast.find(:first, :select => "count(*) as total", :conditions => ["challenge_id = ?", challenge]).total
      total_null_cast = Cast.find(:first, :select => "count(*) as total", 
      :conditions => ["challenge_id = ? and home_score is null and away_score is null", challenge]).total

      if (total_cast.to_i == total_null_cast.to_i)
        puts "cup: #{cup.name}"
        puts "number_of_games: #{number_of_games.to_i}"
        puts "challenge: #{challenge.name}"
        puts "total_cast: #{total_cast.to_i}"
        puts "total_null_cast: #{total_null_cast.to_i}"
        
        challenge.archive = true
        challenge.save!
        
        @casts = Cast.find(:all, :conditions => ["challenge_id = ?", challenge])
        @casts.each do |cast|
          cast.archive = true
          cast.save!
        end
        
      end
      
    end
    
  end

end
