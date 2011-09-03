# to run:    sudo rake the_duplicate_match

desc "archive duplicate matches"
task :the_duplicate_match => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @matches = Match.find(:all, :select => "schedule_id, user_id, count(*) as total", :conditions => "matches.archive = false",
  :group => "schedule_id, user_id", :having => "count(*) > 1")

  @matches.each do |match|
    
    a_match = Match.find(:all, :conditions => ["schedule_id = ? and user_id = ? and archive = false and type_id = 3 and group_score is null and invite_score is null ", match.schedule_id, match.user_id])
    a_match.each do |the_match|
      
      puts "group / schedule: #{match.schedule.group.name} (#{match.schedule.concept}), #{match.user_id } - #{match.total}"
      puts "archiving:     #{the_match.schedule_id} #{the_match.user_id}"

      the_match.archive = true
      the_match.save
    end

  end

end