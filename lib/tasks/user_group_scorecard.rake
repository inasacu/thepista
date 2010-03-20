# to run:    sudo rake theuserscorecard

desc "creating a scorecard for user in group"
task :theuserscorecard => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # groups = Group.find(:all)
  # groups.each do |group|
  #   group.users.each do |user|
  #     Scorecard.create_user_scorecard(user, group) 
  #     puts "#{user.name} - #{Scorecard.user_group_exists?(user, group)}"
  #   end
  # end

end

