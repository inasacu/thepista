
require "uri"
require "net/http"


require 'net/https'
require 'open-uri'

# to run:    heroku run rake the_yo_request --app zurb

desc "adding a yo request for today's event"
task :the_yo_request => :environment do |t|

  puts "request 1"
  params = {'api_token' => ENV["YO_API"], 'username' => 'HAYPISTA', 'trigger' => 'Hay Partido!', 'button' => 'Submit'}
  the_request = Net::HTTP.post_form(URI.parse("#{YO_REQUEST_URL}"), params)
  puts the_request.body
  puts ""

    
  matches = Match.find(:all, :select => "matches.*",
                          :joins => "left join schedules on schedules.id = matches.schedule_id",
                          :joins => "left join users on users.id = matches.user_id",
                          :conditions => ["users.yo_username is not null and matches.user_id = ? and schedules.starts_at > ? and schedules.ends_at < ? and 
                                           schedules.played = false and schedules.archive = false and matches.archive = false", user, Time.zone.now, NEXT_SEVEN_DAYS])
                                           
                                           
   matches.each do |match|
     params = {'api_token' => ENV["YO_API"], 'username' => '#{match.user.yo_username}', 'trigger' => 'Hay Partido!', 'button' => 'Submit'}
     the_request = Net::HTTP.post_form(URI.parse("#{YO_REQUEST_URL}"), params)
     puts the_request.body
     puts ""

     match.schedule.send_reminder_at = Time.zone.now
     match.schedule.save!
   end 

 # end



  # puts "request 2"
  # url = URI.parse(YO_REQUEST_URL)
  # req = Net::HTTP::Post.new(url.request_uri)
  # req.set_form_data({'api_token' => ENV["YO_API"], 'username' => 'HAYPISTA', 'trigger' => 'Hay Partido!'})
  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = (url.scheme == "https")
  # response = http.request(req)
  # puts url
  # puts ""
  
  # puts "request 3"
  # url = URI.parse(YO_REQUEST_URL)
  # req = Net::HTTP::Post.new(url.path)
  # # req.form_data = data
  # req.set_form_data({'api_token' => ENV["YO_API"], 'username' => 'HAYPISTA', 'trigger' => 'Hay Partido!'})
  # # req.basic_auth url.user, url.password if url.user
  # con = Net::HTTP.new(url.host, url.port)
  # # con.use_ssl = true
  # con.start {|http| http.request(req)}
  # puts ""
  
end

