# to run:    sudo rake theschedule_tags

desc "create tags for all the currect schedules"
task :theschedule_tags => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # delete all current tags
  # Tag.find(:all).each do |tag|
  #   puts "remove tag:  #{tag.id}"
  #   tag.destroy
  # end
  # 
  # Tagging.find(:all).each do |tagging|
  #   puts "remove tagging:  #{tagging.id}"
  #   tagging.destroy
  # end

  #remove period from user name
  User.find(:all, :conditions => "name like '%.%'").each do |user|
    user.name = user.name.gsub('.', '')
    user.save!
  end
  
  # creating tags for current schedules
  @schedules_for_tagging = Schedule.find(:all, :conditions => "group_id != 1", :order => "id")
  
  @schedules_for_tagging.each do |schedule|
    @matches = Match.find(:all, :conditions => ["schedule_id = ? and type_id  = 1", schedule.id])    
    @taggables = Tagging.find(:all, :conditions => ["taggable_id = ? and taggable_type = ?", schedule.id, schedule.class.to_s])
  
    total_matches = 0
    total_taggables = 0
    
    @matches.each {|match| total_matches += 1}
    @taggables.each {|taggable| total_taggables += 1}
        
    total_matches = total_matches + 5
    total_tags = total_taggables
  
    # puts  "#{total_matches} == #{total_tags} => (#{schedule.id}), #{schedule.concept}"
  
    unless total_matches == total_tags
  
      @taggables.each do |taggable|
        taggable.destroy
        # puts "remove:  (#{taggable.taggable_id}) #{taggable.taggable_type}"
      end
    end
  end
  
  
  @schedules_for_tagging.each do |schedule|
    # puts "schedule: (#{schedule.id})"
  
    # puts ">= #{schedule.starts_at} - #{schedule.ends_at}" if schedule.starts_at >= schedule.ends_at
    # puts "<= #{schedule.starts_at} - #{schedule.ends_at}" if schedule.ends_at <= schedule.starts_at
    schedule.ends_at = schedule.starts_at + 1.hour        if schedule.starts_at >= schedule.ends_at
  
  
    @matches = Match.find(:all, :conditions => ["schedule_id = ? and type_id  = 1", schedule.id])    
    @taggables = Tagging.find(:all, :conditions => ["taggable_id = ? and taggable_type = ?", schedule.id, schedule.class.to_s])
  
    total_matches = 0
    total_taggables = 0
    
    @matches.each {|match| total_matches += 1}
    @taggables.each {|taggable| total_taggables += 1}
        
    total_matches = total_matches + 5
    total_tags = total_taggables
  
    # puts  "#{total_matches} == #{total_tags} => (#{schedule.id}), #{schedule.concept}"
  
    unless total_matches == total_tags
      # :tags
      # puts "create tags here:  "
      tags = []
      schedule.the_roster.each { |roster| tags << roster.user.name }
          
      tags << schedule.concept
      tags << schedule.group.name
      tags << schedule.group.time_zone
      tags << schedule.group.marker.name
      tags << schedule.group.sport.name
          
      # puts tags
          
      schedule.tag_list = tags
      schedule.save!
    end
  
  end
  
  
  # # creating tags for scorecards, top 5 in the rank only 
  # Group.find(:all).each do |group|        
  #   @scorecards = Scorecard.find(:all, 
  #   :conditions =>["group_id = ? and user_id > 0 and archive = ? and (ranking >= 1 and ranking <= 5) and played > 0", group, false],
  #   :order => 'ranking')        
  #   @scorecards.each do |scorecard|                  
  #     tag_counter = (scorecard.points/10).round                  
  #     tag_counter.times { 
  #       puts "scorecard tag:  #{scorecard.user.name}"
  #       scorecard.ranking_list = scorecard.user.name 
  #     }                  
  #     scorecard.save!        
  #   end      
  # end

end