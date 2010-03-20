# to run:    sudo rake thepayment

desc "fixing issues w/ fees and payment data"
task :thepayment => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # Fee.find(:all).each {|fee| fee.destroy }
  #  
  # Group.find(:all).each do |group|
  #   group.schedules.each do |schedule| 
  #     puts "#{schedule.id} - #{schedule.concept} - #{schedule.group.name}"
  #     counter = Time.zone.now
  #     Fee.create_user_fees(schedule) 
  #     puts "#{counter} - #{Time.zone.now}"
  #     counter = Time.zone.now
  #     Fee.create_group_fees(schedule)
  #     puts "#{counter} - #{Time.zone.now}"
  #   end 
  # end
  # 
  # fees = Fee.find(:all, :conditions => "credit_id = 1 and credit_type = 'Group'")
  # fees.each {|fee| fee.archive = true; fee.save! }
end





