# to run:    sudo rake therpxnow

desc "associate all identity_url to rpxnow_id...same as what rpxnow does but on local. call with RAILS_ENV=production or it defaults to development"
task :therpxnow => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
   
  users = (User.find :all, :conditions => ['archive = false']).collect {|user| user unless user.email.blank? }.compact
  users.each do |user|    
      user.rpxnow_id = user.id
      user.save!
  end

end





