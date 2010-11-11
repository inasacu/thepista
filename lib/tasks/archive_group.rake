# to run:    sudo rake the_archive_group

desc "archive groups with event older than 1 1/2 years"
task :the_archive_group => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # archive group 
  has_to_archive = true
  group_id = [1, 6, 7, 8]  
  schedule_counter = 0
  match_counter = 0
  scorecard_counter = 0
  needs_archiving = 

  the_groups = Group.find(:all, :conditions => ["id in (?)", group_id])
  the_groups.each do |group|

    # archive all schedules for group 
    the_schedules = Schedule.find(:all, :conditions => ["group_id = ? and archive = false", group])  
    the_schedules.each do |schedule|
      puts "#{schedule_counter+=1} => #{schedule.concept} #{schedule.group.name} #{schedule.starts_at}"

      # archive all matches for schedule
      the_matches = Match.find(:all, :conditions => ["schedule_id = ? and archive = false", schedule])
      the_matches.each do |match|      
        puts "match => #{match.id}"
        match.archive = true
        match.save if has_to_archive  
      end  

      # archive all forums for schedule
      the_forums = Forum.find(:all, :conditions => ["schedule_id = ? and archive = false", schedule])
      the_forums.each do |forum|      
        puts "forum => #{forum.id} "

        # archive all comments for forums
        the_comments = Comment.find(:all, :conditions => ["commentable_id = ? and commentable_type = ? and archive = false", forum, forum.class.to_s])
        the_comments.each do |comment|
          puts "comment => #{comment.id} "
          comment.archive = true
          comment.save if has_to_archive
        end

        forum.archive = true
        forum.save if has_to_archive  
      end

      schedule.archive = true
      schedule.save if has_to_archive  
    end

    puts "..."

    # archive all scorecards for group id
    the_scorecards = Scorecard.find(:all, :conditions => ["group_id = ? and archive = false", group])
    the_scorecards.each do |scorecard|    
      puts "#{scorecard_counter+=1} => #{scorecard.group.name}"    
      scorecard.archive = true
      scorecard.save if has_to_archive  
    end

    puts "..."

    # archive roles entries
    the_roles = Role.find(:all, :conditions => ["authorizable_id = ? and authorizable_type = ? and archive = false", group, group.class.to_s])
    the_roles.each do |role|
      puts "role: #{role.id}" 

      the_roles_users = RolesUsers.find(:all, :conditions => ["role_id = ? and archive = false", role])
      the_roles_users.each do |role_user|
        puts "role_user: #{role_user.role_id} #{role_user.user_id}"

        role_user.archive = true
        role_user.save if has_to_archive

      end
      role.archive = true
      role.save if has_to_archive
    end
    
    puts "archive group => #{group.name}"
    group.archive = true
    group.save if has_to_archive
    
    # send message to team manager

  end

  # delete all archived roles and roles_users
  # the_roles = Role.find(:all, :conditions => ["archive = true"])
  # the_roles.each do |role|
  #   puts "role: #{role.id} - archive" if has_to_archive
  #   # role.destroy if has_to_archive
  # end
  # 
  # the_roles_users = RolesUsers.find(:all, :conditions => ["archive = true"])
  # the_roles_users.each do |role_user|
  #   puts "role_user: #{role_user.role_id} - archive" if has_to_archive
  #   # role_user.save if has_to_archive
  # end

end
