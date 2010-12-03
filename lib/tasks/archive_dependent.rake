# to run:    sudo rake the_archive_dependent

desc "archive dependent records to already archived"
task :the_archive_dependent => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # archive flag
  has_to_archive = true  

  # archive all challenges for cups archived 
  the_archive = Challenge.find(:all, :select => "distinct *", :conditions => "archive = false and cup_id in (select id from cups where archive = true)")
  the_archive.each do |challenge|
    puts "archive challenge => #{challenge.id}, cup => #{challenge.cup.name}"
    challenge.archive = true
    challenge.save if has_to_archive
  end
  
  # archive all casts for challenges archived 
  the_archive = Cast.find(:all, :select => "distinct *", 
  :conditions => "archive = false and challenge_id in (select id from challenges where archive = true)")
  the_archive.each do |cast|
    puts "archive cast => #{cast.id}, cup => #{cast.challenge.name}"
    cast.archive = true
    cast.save if has_to_archive
  end 
  
  # archive all schedules for groups archived 
  the_archive = Schedule.find(:all, :select => "distinct *", :conditions => "archive = false and group_id in (select id from groups where archive = true)")  
  the_archive.each do |schedule|
    puts "archive schedule => #{schedule.concept}, group => #{schedule.group.name}"
    schedule.archive = true
    schedule.save if has_to_archive
  end

  # archive all matches for schedules archived 
  the_archive = Match.find(:all, :select => "distinct *", :conditions => "archive = false and schedule_id in (select id from schedules where archive = true)") 
  the_archive.each do |match|
    puts "archive match => #{match.name}, schedule => #{match.schedule.concept}"
    match.archive = true
    match.description = match.schedule.concept if match.description.blank?
    match.save! if has_to_archive
  end

  # archive all scorecards for groups archived 
  the_archive = Scorecard.find(:all, :select => "distinct *", :conditions => "archive = false and group_id in (select id from groups where archive = true)")
  the_archive.each do |scorecard|
    puts "archive scorecard => #{scorecard.id}, group => #{scorecard.group.name}"
    scorecard.archive = true
    scorecard.save if has_to_archive
  end

  # archive all forums for schedules archived 
  the_archive = Forum.find(:all, :select => "distinct *", :conditions => "archive = false and schedule_id in (select id from schedules where archive = true)")
  the_archive.each do |forum|
    puts "archive forum => #{forum.name} #{forum.schedule.concept}"
    forum.archive = true
    forum.save if has_to_archive
  end

  # archive all comments for all commentable_type archived 
  the_item_types = Comment.find(:all, :select => "distinct commentable_type")
  the_item_types.each do |comment|
    # puts "commentable_type => #{comment.commentable_type}"
    the_archive = []    
    case comment.commentable_type
    when "Blog"
      the_archive = Comment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and commentable_type = 'Blog' and commentable_id in (select id from blogs where archive = true)")
    when "Forum"
      the_archive = Comment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and commentable_type = 'Forum' and commentable_id in (select id from forums where archive = true)")
    end  
    the_archive.each do |comment|
      puts "archive comment => #{comment.id},  #{comment.commentable_id} #{comment.commentable_type}"
      comment.archive = true
      comment.save if has_to_archive
    end
  end

  # archive all blogs for all item_type archived 
  the_item_types = Blog.find(:all, :select => "distinct item_type")
  the_item_types.each do |blog|
    # puts "item_type => #{blog.item_type}"
    the_archive = []    
    case blog.item_type
    when "User"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'User' and item_id in (select id from users where archive = true)")
    when "Group"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Blog.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
    end  
    the_archive.each do |blog|
      puts "archive blog => #{blog.id},  #{blog.item_id} #{blog.item_type}"
      blog.archive = true
      blog.save if has_to_archive
    end
  end

  # archive all fees for all item_type archived 
  the_item_types = Fee.find(:all, :select => "distinct item_type")
  the_item_types.each do |fee|
    # puts "item_type => #{fee.item_type}"
    the_archive = []    
    case fee.item_type
    when "Schedule"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Schedule' and item_id in (select id from schedules where archive = true)")
    when "Group"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Fee.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
    end  
    the_archive.each do |fee|
      puts "archive fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
      fee.archive = true
      fee.save if has_to_archive
    end
  end

  # archive all payments for all item_type archived 
  the_item_types = Payment.find(:all, :select => "distinct item_type")
  the_item_types.each do |payment|
    # puts "item_type => #{payment.item_type}"
    the_archive = []    
    case payment.item_type
    when "Schedule"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Schedule' and item_id in (select id from schedules where archive = true)")
    when "Group"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Group' and item_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Payment.find(:all, :select => "distinct *", 
      :conditions => "archive = false and item_type = 'Challenge' and item_id in (select id from challenges where archive = true)")
    end  
    the_archive.each do |payment|
      puts "archive fee => #{payment.id},  #{payment.item_id} #{payment.item_type}"
      payment.archive = true
      payment.save if has_to_archive
    end
  end 

  # archive all slugs for all sluggable_type archived 
  the_item_types = Slug.find(:all, :select => "distinct sluggable_type")
  the_item_types.each do |slug|
    # puts "sluggable_type => #{slug.sluggable_type}"
    the_archive = []    
    case slug.sluggable_type
    when "User"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'User' and sluggable_id in (select id from users where archive = true)")
    when "Group"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Group' and sluggable_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Challenge' and sluggable_id in (select id from challenges where archive = true)")
    when "Schedule"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Schedule' and sluggable_id in (select id from schedules where archive = true)")
    when "Blog"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Blog' and sluggable_id in (select id from blogs where archive = true)")
    when "Fee"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Fee' and sluggable_id in (select id from fees where archive = true)")
    when "Payment"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Payment' and sluggable_id in (select id from payments where archive = true)")
    when "Cup"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Cup' and sluggable_id in (select id from cups where archive = true)")
    when "Game"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Game' and sluggable_id in (select id from games where archive = true)")
    when "Forum"
      the_archive = Slug.find(:all, :select => "distinct *", 
      :conditions => "archive = false and sluggable_type = 'Forum' and sluggable_id in (select id from forums where archive = true)")
    end  
    the_archive.each do |slug|
      puts "archive slug => #{slug.id},  #{slug.sluggable_id} #{slug.sluggable_type}"
      slug.archive = true
      slug.save if has_to_archive
    end
  end

  # archive all roles for all authorizable_type archived 
  the_item_types = Role.find(:all, :select => "distinct authorizable_type")
  the_item_types.each do |role|
    # puts "authorizable_type => #{role.authorizable_type}"
    the_archive = []    
    case role.authorizable_type
    when "User"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'User' and authorizable_id in (select id from users where archive = true)")
    when "Group"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Group' and authorizable_id in (select id from groups where archive = true)")
    when "Challenge"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Challenge' and authorizable_id in (select id from challenges where archive = true)")
    when "Schedule"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Schedule' and authorizable_id in (select id from schedules where archive = true)")
    when "Blog"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Blog' and authorizable_id in (select id from blogs where archive = true)")
    when "Fee"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Fee' and authorizable_id in (select id from fees where archive = true)")
    when "Payment"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Payment' and authorizable_id in (select id from payments where archive = true)")
    when "Cup"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Cup' and authorizable_id in (select id from cups where archive = true)")
    when "Game"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Game' and authorizable_id in (select id from games where archive = true)")
    when "Forum"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Forum' and authorizable_id in (select id from forums where archive = true)")
    when "Marker"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Marker' and authorizable_id in (select id from markers where archive = true)")
    when "Classified"
      the_archive = Role.find(:all, :select => "distinct *", 
      :conditions => "archive = false and authorizable_type = 'Classified' and authorizable_id in (select id from classifieds where archive = true)")
    end  
    the_archive.each do |role|
      puts "archive slug => #{role.id},  #{role.authorizable_id} #{role.authorizable_type}"
      role.archive = true
      role.save if has_to_archive
    end
  end

  # archive all roles_users for roles archived 
  the_archive = RolesUsers.find(:all, :select => "distinct *", 
  :conditions => "archive = false and role_id in (select id from roles where archive = true)")
  the_archive.each do |role_user|
    puts "archive role_user => #{role_user.id}, #{role_user.role_id}"
    role_user.archive = true
    role_user.save if has_to_archive
  end
end
