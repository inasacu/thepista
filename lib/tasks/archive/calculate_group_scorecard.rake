# to run:    rake calculate_group_scorecard

desc "calculate group scorecard"
task :calculate_group_scorecard => :environment do |t|
  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  Scorecard.calculate_group_scorecard(Group.find(9))
end




