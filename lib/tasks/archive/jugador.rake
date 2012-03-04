# to run:    sudo rake thejugador

desc "update user technical and physical levels if null"
task :thejugador => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  users = User.find(:all, :conditions => 'technical is null or physical is null')
  users.each do |user|
    puts user.name
    user.technical = 1
    user.physical = 1
    user.save! 
  end


end

