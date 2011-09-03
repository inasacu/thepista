# to run:    sudo rake the_user_last_minute

desc "copy all user emails to email backup and last_minute notification"
task :the_user_last_minute => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @users = User.find(:all, :conditions => 'archive = false')
  @users.each do |user|
    puts user.name
    user.last_minute_notification = true
    user.email_backup = user.email
    user.save  
  end

  # adding more sports
  [
    ['Escalada', 'Escalada', 'wall.png', 1,  0,  0,  8], 
    ['Tenis de Mesa', 'Tenis de Mesa', 'tennis.gif', 1,  0,  0,  4],    
    ['Voley Playa', 'Voley Playa', 'volleyball.png',  1,  0,  0,  10],    
    ['Fútbol Playa', 'Fútbol Playa', 'futbol.gif',  3,  1,  0,  12]
    ].each do |sport|
      Sport.create(:name => sport[0], :description => sport[1], :icon => sport[2],  
      :points_for_win => sport[3], :points_for_lose => sport[4], :points_for_draw => sport[5], :player_limit => sport[6] )
    end

    the_sport = Sport.find(:all, :conditions => "name = 'Padel'")
    the_sport.each do |sport|
      sport.name = 'Pádel'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

    the_sport = Sport.find(:all, :conditions => "name = 'Volleyball'")
    the_sport.each do |sport|
      sport.name = 'Voleibol'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

    the_sport = Sport.find(:all, :conditions => "name = 'Futbol 11'")
    the_sport.each do |sport|
      sport.name = 'Fútbol'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

    the_sport = Sport.find(:all, :conditions => "name = 'FutSal'")
    the_sport.each do |sport|
      sport.name = 'Fútbol Sala'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

    the_sport = Sport.find(:all, :conditions => "name = 'Futbol 7'")
    the_sport.each do |sport|
      sport.name = 'Fútbol 7'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

    the_sport = Sport.find(:all, :conditions => "name = 'Basketball'")
    the_sport.each do |sport|  
      sport.name = 'Baloncesto'
      sport.description = sport.name
      sport.save
      puts sport.name
    end

end
