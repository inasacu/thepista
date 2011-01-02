# to run:    sudo rake sync_fee_type_match

desc "sync fees type id with match type id"
task :sync_fee_type_match => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  all_match_fees = Fee.find(:all, :conditions => ["debit_type = 'User' and item_type = 'Schedule'"])
  all_match_fees.each do |fee|
    the_match = Match.find(:first, :conditions =>["archive = false and user_id = ? and schedule_id = ?", fee.debit_id, fee.item_id])

    if (fee.type_id != the_match.type_id and the_match.user_id == fee.debit_id)
      puts "the_match.user_id: #{the_match.user_id}, fee.debit_id: #{fee.debit_id}, fee.type_id: #{fee.type_id}, the_match.type_id: #{the_match.type_id}"
      fee.type_id = the_match.type_id 
      fee.save
    end
  end

end