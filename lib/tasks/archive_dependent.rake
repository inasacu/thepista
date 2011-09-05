# to run:    sudo rake the_archive_dependent

desc "ARCHIVE dependent records to already archived"
task :the_archive_dependent => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # ARCHIVE flag
  has_to_archive = true  

  # ARCHIVE all CHALLENGES for CUPS archived 
  the_challenge = Challenge.find(:all, :select => "distinct *", :conditions => "archive = false and cup_id in (select id from cups where archive = true)")
  
  the_challenge.each do |challenge|
    puts "ARCHIVE challenge => #{challenge.id}, cup => #{challenge.cup.name}"
    challenge.archive = true
    challenge.save if has_to_archive
  end
  
  # ARCHIVE all CASTS for CHALLENGES archived 
  the_cast = Cast.find(:all, :select => "distinct *", :conditions => "archive = false and challenge_id in (select id from challenges where archive = true)")
  
  the_cast.each do |cast|
    puts "ARCHIVE cast => #{cast.id}, cup => #{cast.challenge.name}"
    cast.archive = true
    cast.save if has_to_archive
  end 
  
  # ARCHIVE all SCHEDULES for GROUPS archived 
  the_schedule = Schedule.find(:all, :select => "distinct *", :conditions => "archive = false and group_id in (select id from groups where archive = true)") 
  
  the_schedule.each do |schedule|
    puts "ARCHIVE schedule => #{schedule.concept}, group => #{schedule.group.name}"
    schedule.archive = true
    schedule.save if has_to_archive
  end

  # ARCHIVE all MATCHES for SCHEDULES archived 
  the_match = Match.find(:all, :select => "distinct *", :conditions => "archive = false and schedule_id in (select id from schedules where archive = true)") 
  
  the_match.each do |match|
    puts "ARCHIVE match => #{match.name}, schedule => #{match.schedule.concept}"
    match.archive = true
    match.description = match.schedule.concept if match.description.blank?
    match.save! if has_to_archive
  end

  # ARCHIVE all SCORECARDS for GROUPS archived 
  the_scorecard = Scorecard.find(:all, :select => "distinct *", :conditions => "archive = false and group_id in (select id from groups where archive = true)")
  
  the_scorecard.each do |scorecard|
    puts "ARCHIVE scorecard => #{scorecard.id}, group => #{scorecard.group.name}"
    scorecard.archive = true
    scorecard.save if has_to_archive
  end

  # ARCHIVE all FORUMS for SCHEDULES archived 
  # the_forum = Forum.find(:all, :select => "distinct *", :conditions => "archive = false and schedule_id in (select id from schedules where archive = true)")
  # 
  # the_forum.each do |forum|
  #   puts "ARCHIVE forum => #{forum.name} #{forum.schedule.concept}"
  #   forum.archive = true
  #   forum.save if has_to_archive
  # end
  
  # ARCHIVE all BLOGS for all ITEM_TYPE archived 
  # the_item_types = Blog.find(:all, :select => "distinct item_type")
  # the_item_types.each do |blog|
  #   puts "item_type => #{blog.item_type}"
  #   the_archive = []    
  #   case blog.item_type
  #   when "User"
  #     the_archive = Blog.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'User' and item_id in (select id from users where archive = true)")
  #   when "Group"
  #     the_archive = Blog.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
  #   when "Challenge"
  #     the_archive = Blog.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
  #   when "Venue"
  #     the_archive = Blog.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Venue' and item_id in (select id from venues where archive = true)")
  #   end
  # 
  #   the_archive.each do |blog|
  #     puts "ARCHIVE blog => #{blog.id},  #{blog.item_id} #{blog.item_type}"
  #     blog.archive = true
  #     blog.save if has_to_archive
  #   end
  # 
  # end  
  
  # ARCHIVE all COMMENTS for all COMMENTABLE_TYPE archived 
  # the_archive = Comment.find(:all, :select => "distinct *", 
  #                :conditions => "archive = false and commentable_type = 'Blog' and commentable_id in (select id from blogs where archive = true)")               
  #                
  # the_archive.each do |comment|
  #   puts "ARCHIVE comment => #{comment.id},  #{comment.commentable_id} #{comment.commentable_type}"
  #   comment.archive = true
  #   comment.save if has_to_archive
  # end
  # 
  # the_archive = Comment.find(:all, :select => "distinct *", 
  #                :conditions => "archive = false and commentable_type = 'Forum' and commentable_id in (select id from forums where archive = true)")               
  #                
  # the_archive.each do |comment|
  #   puts "ARCHIVE comment => #{comment.id},  #{comment.commentable_id} #{comment.commentable_type}"
  #   comment.archive = true
  #   comment.save if has_to_archive
  # end
  
  # ARCHIVE all FEES for all ITEM_TYPE archived 
  # the_item_types = Fee.find(:all, :select => "distinct item_type")
  # the_item_types.each do |fee|
  #   puts "item_type => #{fee.item_type}"
  #   the_archive = []    
  #   case fee.item_type
  #   when "Schedule"
  #     the_archive = Fee.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Schedule' and item_id in (select id from schedules where archive = true)")
  #   when "Group"
  #     the_archive = Fee.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
  #   when "Challenge"
  #     the_archive = Fee.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
  #   end  
  #   the_archive.each do |fee|
  #     puts "ARCHIVE fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
  #     fee.archive = true
  #     fee.save if has_to_archive
  #   end
  # end
  
  # ARCHIVE all PAYMENTS for all ITEM_TYPE archived 
  # the_item_types = Payment.find(:all, :select => "distinct item_type")
  # the_item_types.each do |payment|
  #   puts "item_type => #{payment.item_type}"
  #   the_archive = []    
  #   case payment.item_type
  #   when "Schedule"
  #     the_archive = Payment.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Schedule' and item_id in (select id from schedules where archive = true)")
  #   when "Group"
  #     the_archive = Payment.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
  #   when "Challenge"
  #     the_archive = Payment.find(:all, :select => "distinct *", 
  #     :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
  #   end  
  #   the_archive.each do |payment|
  #     puts "ARCHIVE fee => #{payment.id},  #{payment.item_id} #{payment.item_type}"
  #     payment.archive = true
  #     payment.save if has_to_archive
  #   end
  # end  
  
  
  # unarchive group 
  group_id = [6]  

  # unarchive groups listed above
  the_archive = Group.find(:all, :conditions => ["id in (?)", group_id])
  the_archive.each do |group|    
    puts "unarchive group => #{group.name}"
    group.archive = false
    group.save if has_to_archive
  end 
  
end
