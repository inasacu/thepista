# to run:    sudo rake the_match_scorecard_update

desc "create games based on cup teams and groups..."
task :the_match_scorecard_update => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  @the_match = Match.find(:first, :conditions =>"schedule_id = (select id from schedules where group_id = 9 and played = true order by starts_at desc limit 1)")
  puts @the_match.name
  Match.update_match_details(@the_match, false)

end

