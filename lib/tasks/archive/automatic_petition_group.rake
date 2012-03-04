# to run:    sudo rake the_automatic_petition_group

desc "archive specified groups"
task :the_automatic_petition_group => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  the_group = Group.find(:all)
  the_group.each do |group|    
    puts "set group automatic petition => #{group.name}"
    group.automatic_petition = true
    group.save
  end

    the_challenge = Challenge.find(:all)
    the_challenge.each do |challenge|    
      puts "set challenge automatic petition => #{challenge.name}"
      challenge.automatic_petition = true
      challenge.save
    end

end