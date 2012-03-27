# to run:    sudo rake the_archive_dependent

desc "ARCHIVE dependent records to already archived"
task :the_archive_dependent => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  
  counter = 0

  all_archive = Comment.find(:all, :conditions => "archive is null")
  all_archive.each do |the_archive|
    the_archive.archive = false
    the_archive.save
  end
  
  all_remove = Comment.find(:all, :conditions => "commentable_type is null")
  all_remove.each do |the_remove|
    puts "#{the_remove.id} - #{the_remove.user_id} = #{the_remove.group_id}"
    the_remove.destroy
  end
  
  
  all_remove = Slug.find(:all, :conditions => "sluggable_type = 'Blog'")
  all_remove.each do |the_remove|
    puts "#{the_remove.id}"
    the_remove.destroy
  end

  # set all slugs to archive false where archive is null
  all_archive = Slug.find(:all, :conditions => "archive is null")
  all_archive.each do |the_archive|
    the_archive.archive = false
    the_archive.save
  end
  
  
  # email backup
  the_user = User.find(:all, :conditions => "email_backup is null")
  the_user.each do |user|
    puts "EMAIL BACKUP user => #{user.name}"
    user.email_backup = user.email
    user.save
  end
  
  # archive users last_login_at older than 1 years
  counter = 0
  the_archive = User.find(:all, 
  :conditions => ["archive = false and id not in (select distinct user_id from groups_users where archive = false) and last_login_at < ?", Time.zone.now - 365.days])
  the_archive.each do |user|
    puts "ARCHIVE user => #{user.name} - (#{counter +=1})"
    user.archive = true
    user.save
  end

  # archive group 
  has_to_archive = true
  group_id = [13,17,18]  
  
  the_archive = Group.find(:all, :conditions => ["id in (?) and archive = false", group_id])
  the_archive.each do |group|    
    puts "archive group => #{group.name}"
    group.archive = true
    group.save if has_to_archive
  end
  
  # ARCHIVE all GROUPS_USERS for GROUPS archived 
  the_archive = GroupsUsers.find(:all, :select => "distinct *", 
  :conditions => "archive = false and group_id in (select distinct groups.id from groups where groups.archive = true)") 

  the_archive.each do |group|
    puts "ARCHIVE groups_users => #{group.group_id} #{Group.find(group.group_id).name}"
    group.archive = true
    group.save if has_to_archive
  end


  # set all blogs and forums in archive = null value to false
  all_blogs = Blog.find(:all, :conditions => 'archive is null', :order => 'id')
  all_blogs.each do |blog|
    puts "ARCHIVE blog => #{blog.id},  #{blog.item_id} #{blog.item_type}"

    case blog.item_type
    when "User"
      the_name = User.find(:first, :select => "name", :conditions => ["id = ?", blog.item_id])
    when "Group"
      the_name = Group.find(:first, :select => "name", :conditions => ["id = ?", blog.item_id])
    when "Challenge"
      the_name = Challenge.find(:first, :select => "name", :conditions => ["id = ?", blog.item_id])
    when "Venue"
      the_name = Venue.find(:first, :select => "name", :conditions => ["id = ?", blog.item_id])
    end

    if the_name
      blog.name = the_name.name 
      blog.archive = false
    else
      blog.archive = true
      blog.name = 'archive'
    end
    blog.save if has_to_archive

  end

  all_forums = Forum.find(:all, :conditions => 'archive is null', :order => 'id')
  all_forums.each do |forum|
    puts "ARCHIVE blog => #{forum.id}"
    forum.archive = false
    forum.save if has_to_archive
  end

  # ARCHIVE flag
  has_to_archive = true  

  # ARCHIVE all CHALLENGES for CUPS archived 
  the_challenge = Challenge.find(:all, :select => "distinct *", 
  :conditions => "archive = false and cup_id in (select distinct cups.id from cups where cups.archive = true)")

  the_challenge.each do |challenge|
    puts "ARCHIVE challenge => #{challenge.id}, cup => #{challenge.cup.name}"
    challenge.archive = true
    challenge.save if has_to_archive
  end

  # ARCHIVE all CASTS for CHALLENGES archived 
  the_cast = Cast.find(:all, :select => "distinct *", 
  :conditions => "archive = false and challenge_id in (select distinct challenges.id from challenges where challenges.archive = true)")

  the_cast.each do |cast|
    puts "ARCHIVE cast => #{cast.id}, cup => #{cast.challenge.name}"
    cast.archive = true
    cast.save if has_to_archive
  end 

  # ARCHIVE all SCHEDULES for GROUPS archived 
  the_schedule = Schedule.find(:all, :select => "distinct *", 
  :conditions => "archive = false and group_id in (select distinct groups.id from groups where groups.archive = true)") 

  the_schedule.each do |schedule|
    puts "ARCHIVE schedule => #{schedule.concept}, group => #{schedule.group.name}"
    schedule.archive = true
    schedule.save if has_to_archive
  end

  # ARCHIVE all MATCHES for SCHEDULES archived 
  the_match = Match.find(:all, :select => "distinct *", 
  :conditions => "archive = false and schedule_id in (select distinct schedules.id from schedules where schedules.archive = true)") 

  the_match.each do |match|
    puts "ARCHIVE match => #{match.id}, schedule => #{match.schedule.concept}"
    match.archive = true
    match.description = match.schedule.concept if match.description.blank?
    match.save! if has_to_archive
  end


  # ARCHIVE all MATCHES where schedule_id not in all schedules not archived
  the_match = Match.find(:all, :select => "distinct *",
  :conditions => "matches.archive = false and matches.schedule_id not in (select id from schedules where  archive = false)")

  the_match.each do |match|
    puts "ARCHIVE match => #{match.id}"
    match.archive = true
    match.description = 'archive' if match.description.blank?
    match.save! if has_to_archive
  end


  # ARCHIVE all RATES for all RATEABLE_TYPE archived 
  the_rate_types = Rate.find(:all, :select => "distinct rateable_type")
  the_rate_types.each do |rate|
    
    # puts "rateable_type => #{rate.rateable_type}"
    
    the_archive = []    
    case rate.rateable_type
    when "Schedule"
      the_archive = Rate.find(:all, :select => "distinct *", 
      :conditions => "archive = false and rateable_type = 'Schedule' and rateable_id in (select distinct schedules.id from schedules where schedules.archive = true)")
    when "Match"
      the_archive = Rate.find(:all, :select => "distinct *", 
      :conditions => "archive = false and rateable_type = 'Match' and rateable_id in (select distinct matches.id from matches where matches.archive = true)")
    end  
    the_archive.each do |rate|
      puts "ARCHIVE fee => #{rate.id},  #{rate.rateable_id} #{rate.rateable_type}"
      rate.archive = true
      rate.save if has_to_archive
    end
  end

  # ARCHIVE all SCORECARDS for GROUPS archived 
  the_scorecard = Scorecard.find(:all, :select => "distinct *", 
  :conditions => "archive = false and group_id in (select distinct groups.id from groups where groups.archive = true)")

  the_scorecard.each do |scorecard|
    puts "ARCHIVE scorecard => #{scorecard.id}, group => #{scorecard.group.name}"
    scorecard.archive = true
    scorecard.save if has_to_archive
  end

  # ARCHIVE all FORUMS for SCHEDULES archived 
  the_forum = Forum.find(:all, :select => "distinct *", 
  :conditions => "archive = false and schedule_id in (select distinct schedules.id from schedules where schedules.archive = true)")

  the_forum.each do |forum|
    puts "ARCHIVE forum => #{forum.id} #{forum.schedule.concept}"
    forum.archive = true
    forum.save if has_to_archive
  end

  # ARCHIVE all BLOGS for all ITEM_TYPE archived 
  the_item_types = Blog.find(:all, :select => "distinct item_type")
  the_item_types.each do |blog|
    
    # puts "item_type => #{blog.item_type}"
    
    the_archive = []    
    case blog.item_type
    when "User"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'User' and item_id in (select distinct users.id from users where users.archive = true)")
    when "Group"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select distinct groups.id from groups where groups.archive = true)")
    when "Challenge"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select distinct challenges.id from challenges where challenges.archive = true)")
    when "Venue"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Venue' and item_id in (select distinct venues.id from venues where venues.archive = true)")
    end

    the_archive.each do |blog|
      puts "ARCHIVE blog => #{blog.id},  #{blog.item_id} #{blog.item_type}"
      blog.archive = true
      blog.save if has_to_archive
    end

  end  

  # ARCHIVE all COMMENTS for all COMMENTABLE_TYPE archived 
  the_archive = Comment.find(:all, :select => "distinct *", 
  :conditions => "archive = false and commentable_type = 'Blog' and commentable_id in (select distinct blogs.id from blogs where blogs.archive = true)")               

  the_archive.each do |comment|
    puts "ARCHIVE comment => #{comment.id},  #{comment.commentable_id} #{comment.commentable_type}"
    comment.archive = true
    comment.save if has_to_archive
  end

  the_archive = Comment.find(:all, :select => "distinct *", 
  :conditions => "archive = false and commentable_type = 'Forum' and commentable_id in (select distinct forums.id from forums where forums.archive = true)")               

  the_archive.each do |comment|
    puts "ARCHIVE comment => #{comment.id},  #{comment.commentable_id} #{comment.commentable_type}"
    comment.archive = true
    comment.save if has_to_archive
  end

  # ARCHIVE all FEES for all ITEM_TYPE archived 
  the_item_types = Fee.find(:all, :select => "distinct item_type")
  the_item_types.each do |fee|
    
    puts "item_type => #{fee.item_type}"
    
    the_archive = []    
    case fee.item_type
    when "Schedule"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Schedule' and item_id in (select distinct schedules.id from schedules where schedules.archive = true)")
    when "Group"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select distinct groups.id from groups where groups.archive = true)")
    when "Challenge"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select distinct challenges.id from challenges where challenges.archive = true)")
    end  
    the_archive.each do |fee|
      puts "ARCHIVE fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
      fee.archive = true
      fee.save if has_to_archive
    end
  end
  
  the_archive = Fee.find(:all, :conditions => "item_type = 'Schedule' and item_id not in (select id from schedules where archive = false)")
  the_archive.each do |fee|
    puts "ARCHIVE fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
    fee.archive = true
    fee.save if has_to_archive
  end


  # ARCHIVE all PAYMENTS for all ITEM_TYPE archived 
  the_item_types = Payment.find(:all, :select => "distinct item_type")
  the_item_types.each do |payment|
    
    puts "item_type => #{payment.item_type}"
    
    the_archive = []    
    case payment.item_type
    when "Schedule"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Schedule' and item_id in (select distinct schedules.id from schedules where schedules.archive = true)")
    when "Group"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select distinct groups.id from groups where groups.archive = true)")
    when "Challenge"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select distinct challenges.id from challenges where challenges.archive = true)")
    end  
    the_archive.each do |payment|
      puts "ARCHIVE fee => #{payment.id},  #{payment.item_id} #{payment.item_type}"
      payment.archive = true
      payment.save if has_to_archive
    end
  end  

end
