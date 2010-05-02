# to run:    sudo rake the_teammate

desc "teammate migrate from group to item values"
task :the_teammate => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  @teammates = Teammate.find(:all, :conditions => 'group_id is not null and item_id is null')
  @teammates.each do |teammate|
    teammate.item = teammate.group
    teammate.save!
  end
  
end