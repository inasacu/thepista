# to run:    sudo rake therpxnow

desc "associate all identity_url to rpxnow_id...same as what rpxnow does but on local. call with Rails.env=production or it defaults to development"
task :therpxnow => :environment do |t|

  # option to remove a particular user id and rpxnow object id
  # RPXNow.unmap(2949, 2949, APP_CONFIG['rpx_api']['key'])
    
  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
   
  # users = (User.find :all, :conditions => ['archive = false']).collect {|user| user unless user.email.blank? }.compact
  # users.each do |user|    
  #     user.rpxnow_id = user.id
  #     user.save!
  # end
  # 
  # 
  # ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  # 
  # User.find(:all).each do |user|
  #   myOpenID = RPXNow.mappings(user.id, APP_CONFIG['rpx_api']['key'])
  #   
  #   if myOpenID.length > 0
  #     
  #     myOpenID.each do |identifier| 
  #         
  #       if user.identity_url != identifier
  #         
  #         RPXNow.unmap(identifier, user.id, APP_CONFIG['rpx_api']['key'])
  #         puts "updated #{user.name } has incorrect identity_url and id conbination in rpx_now.com..."
  #       end
  #       
  #     end
  #     
  #   end
  #   
  # end

end



