# to run:    sudo rake thedeporte

desc "add activity id to sport id on group, schedule and tournament...migration"
task :thedeporte => :environment do |t|

  # ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  #       
  # Group.find(:all).each do |group|
  #   group.sport_id = group.activity_id
  #   group.save!
  # end
  # 
  # Schedule.find(:all).each do |schedule|
  #   schedule.sport_id = schedule.activity_id
  #   schedule.save!
  # end
  # 
  # Tournament.find(:all).each do |tournament|
  #   tournament.sport_id = tournament.activity_id
  #   tournament.save!
  # end 
  # 
  # [[1,'Futbol 7','futbol.gif'],
  #   [2,'Futbol 11','futbol.gif'],
  #   [3,'FutSal','futbol.gif'],
  #   [4,'Football','futbol.gif'],
  #   [5,'Soccer','futbol.gif'],
  #   [6,'Golf','golf.gif'],
  #   [7,'Basketball','basketball.gif'],
  #   [8,'Volleyball','futbol.gif'],
  #   [9,'Tennis','tennis.gif'],
  #   [10,'Hockey','futbol.gif'],
  #   [99999,'Other','futbol.gif']].each do |sport|
  #     Sport.create(:id => sport[0], :name => sport[1],  :icon => sport[2])
  # end
  # 
  # 
  # Sport.find(:all, :conditions => "name in ('Futbol 7', 'Futbol 11', 'FutSal', 'Football', 'Soccer')").each do |sport|
  #   sport.points_for_win = 3
  #   sport.points_for_draw = 1
  #   sport.points_for_lose = 0
  #   sport.save!
  # end
  # 
  # Sport.find(:all, :conditions => "name not in ('Futbol 7', 'Futbol 11', 'FutSal', 'Football', 'Soccer')").each do |sport|
  #   sport.points_for_win = 1
  #   sport.points_for_draw = 0
  #   sport.points_for_lose = 0
  #   sport.save!
  # end
       
end

