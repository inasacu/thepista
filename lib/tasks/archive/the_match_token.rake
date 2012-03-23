# to run:    sudo rake the_match_token

desc "add a token per match not played"
task :the_match_token => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  @matches = Match.find(:all, :conditions => "archive = false and played = false")
  @matches.each do |match|

    the_encode = "#{rand(36**8).to_s(36)}#{match.id}#{rand(36**8).to_s(36)}"
    block_token  = Base64::encode64(the_encode)

    puts "match.id:  #{match.id} - #{match.user_id} - #{the_encode} - #{block_token}"  

    match.block_token = block_token
    match.save

  end
end
