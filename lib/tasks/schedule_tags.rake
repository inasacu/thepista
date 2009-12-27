# # :tags, :zones, :locations, :sports
# schedule.tag_list = schedule.concept     
# schedule.zone_list =  schedule.group.time_zone
# schedule.location_list = schedule.group.marker.name
# schedule.sport_list = schedule.group.sport.name

# to run:    sudo rake theschedule_tags

desc "create tags for all the currect schedules"
task :theschedule_tags => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # delete all current tags
  Tag.find(:all).each do |tag|
    puts "remove tag:  #{tag.id}"
    tag.destroy
  end
  
  Tagging.find(:all).each do |tagging|
    puts "remove tagging:  #{tagging.id}"
    tagging.destroy
  end
  
  
  # creating tags for current schedules
  Schedule.find(:all, :conditions => "group_id != 1", :order => "id").each do |schedule|
    puts "schedule: (#{schedule.id})"
    
    puts ">= #{schedule.starts_at} - #{schedule.ends_at}" if schedule.starts_at >= schedule.ends_at
    puts "<= #{schedule.starts_at} - #{schedule.ends_at}" if schedule.ends_at <= schedule.starts_at
    
    schedule.ends_at = schedule.starts_at + 1.hour        if schedule.starts_at >= schedule.ends_at
    
    # :tags, :zones, :locations, :sports
    schedule.tag_list = schedule.concept     
    schedule.zone_list =  schedule.group.time_zone
    schedule.location_list = schedule.group.marker.name
    schedule.sport_list = schedule.group.sport.name
    schedule.save!
  end

  
end