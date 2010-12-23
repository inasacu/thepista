# to run:    sudo rake calculate_group_scorecard

desc "calculate group scorecard"
task :calculate_group_scorecard => :environment do |t|
  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  Scorecard.calculate_group_scorecard(Group.find(9))
end




