
require "uri"
require "net/http"
require 'open-uri'

# to run:    heroku run rake the_yo_request --app zurb

desc "adding a yo request for events within the next 48 hours..."
task :the_yo_request => :environment do |t|

  # puts "sample"
  # params = {'api_token' => ENV["YO_API"], 'username' => 'HAYPISTA', 'button' => 'Submit'}
  # the_request = Net::HTTP.post_form(URI.parse("#{YO_REQUEST_URL_ALL}"), params)
  # puts the_request.body
  # puts ""
  # 
  
  
  uri = URI.parse("#{YO_REQUEST_URL_ALL}")
  
  matches = Match.find(:all, :select => "users.id, users.name, users.email, users.yo_username, matches.schedule_id, matches.type_id", 
                              :joins => "JOIN schedules on schedules.id = matches.schedule_id JOIN users on users.id = matches.user_id",
                              :conditions => ["users.yo_username is not null and users.archive is not null and
                                               schedules.starts_at >= ? and schedules.ends_at <= ? and 
                                               schedules.played = false and schedules.archive = false and 
                                               schedules.send_reminder_at is null and matches.archive = false", Time.zone.now-7.days, NEXT_48_HOURS])
   
   counter = 0                                   
   the_schedules = []                                    
   matches.each do |match|
     
     # response = Net::HTTP.post_form(uri, {'api_token' => ENV["YO_API"], 'username' => '#{match.yo_username}'})
     # puts response.body
     
   
     puts "#{counter+=1}: #{match.yo_username}"
     the_schedules << match.schedule_id unless the_schedules.include?(match.schedule_id)
   end 
   
   schedules = Schedule.find(:all, :select => "send_reminder_at", :conditions => ["id in (?)", the_schedules])
   schedules.each do |schedule|

     response = Net::HTTP.post_form(uri, {'api_token' => ENV["YO_API"]})
     puts response.body

     schedule.send_reminder_at = Time.zone.now
     schedule.save!
   end
  
  
  # uri = URI.parse("#{YO_REQUEST_URL_ALL}")
  # 
  # # Shortcut
  # response = Net::HTTP.post_form(uri, {'api_token' => ENV["YO_API"], 'username' => 'inasacu'})
  # 
  # # Full control
  # # http = Net::HTTP.new(uri.host, uri.port)
  # # request = Net::HTTP::Post.new(uri.request_uri)
  # # request.set_form_data({'api_token' => ENV["YO_API"], 'username' => 'inasacu'})
  # # response = http.request(request)
  # puts response.body
  
  
  
end

