# to run:    sudo rake sync_fee_type_match

desc "sync fees type id with match type id"
task :sync_fee_type_match => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  counter = 0
  all_fees = Fee.find(:all, :select => "fees.*, matches.type_id as match_type_id",
                            :joins => "JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
                            :conditions => ["fees.debit_type = 'User' and fees.item_type = 'Schedule' and matches.archive = false and fees.type_id != matches.type_id"])
  all_fees.each do |fee|
    unless (fee.type_id.to_i == fee.match_type_id.to_i)
    puts "fee.id:  #{fee.id}, user.id: #{fee.debit_id}, type_id: #{fee.type_id}, match_type_id:  #{fee.match_type_id}"
    counter += 1
    the_fee = Fee.find(fee.id)
    the_fee.type_id = fee.match_type_id
    the_fee.save!
    end
  end
  puts "total records changed:  #{counter}"

end