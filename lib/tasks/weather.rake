# to run:    sudo rake the_weather

# require 'barometer'


desc "get the weather forecast"
task :the_weather => :environment do |t|

  # ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  # 
  # # Barometer.google_geocode_key = APP_CONFIG['google_api']['key']
  # # Barometer.config = { 1 => [:yahoo, :google], 2 => :wunderground }
  # # Barometer.force_geocode = true
  # 
  # Group.find(:all).each do |group|
  #   barometer = Barometer.new(group.time_zone)
  #   weather = barometer.measure
  #   
  #   time = Time.parse(Time.zone.now.to_s)
  #   date = Date.parse(Time.zone.now.to_s)
  # 
  #   puts "now.temperature.c  #{weather.now.temperature.c}"
  #   puts "weather.for(date).low #{weather.for(date).low.c}"        
  #   puts "weather.for(date).high #{weather.for(time).high.c}" 
  #   puts "weather.source(yahoo) #{weather.source(:yahoo).current.temperature.c}"  
  #   puts "weather.source(google) #{weather.source(:google).current.temperature.c}"
  #   
  #   puts "wet:    #{weather.wet?}"
  #   puts "sunny:  #{weather.sunny?}"
  #   puts "windy:  #{weather.windy?}"
  #   
  #   # puts "weather.for(date).wet #{weather.for(date).wet?}"       
  #   # puts "weather.for(date).sunny #{weather.for(date).sunny?}"   
  #   # puts "weather.for(date).windy #{weather.for(date).windy?}"       
  # end
end

