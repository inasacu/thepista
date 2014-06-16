desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

# heroku run rake calculate_group_scorecard --app zurb
task :calculate_group_scorecard => :environment do

  # puts "Calculate groups scorecards... A:  #{Time.zone.now}"
  # puts " "
  # 
  # the_groups = Group.find(:all, :conditions => "archive = false")
  # the_groups.each do |group|
  #     puts "Group Name:  #{group.name} - #{Time.zone.now}"
  #     Scorecard.calculate_group_scorecard(group)
  #   end
  #   puts " "
  # puts "Calculate groups scorecards... B:  #{Time.zone.now}"

  the_groups = []
  the_non_players = User.find(:all, :select => "users.id as user_id, users.name as user_name,  
                                                scorecards.id as scorecard_id, scorecards.group_id, 
                                                scorecards.played as scorecard_played, 
                                                scorecards.points, (100 * scorecards.played / 36) as coeficient_played",
                              :joins => "left join scorecards on scorecards.user_id = users.id",
                              :conditions => "users.id not in (1, 2, 3) and users.archive = false 
                                              and scorecards.archive = false
                                              and (100 * scorecards.played / 36) = 0")

  the_non_players.each do |player|
    puts "Archive user groups scorecards... A:  #{Time.zone.now}"
    
    the_user = User.find(player.user_id)
    the_group = Group.find(player.group_id)
    

    the_groups << the_group unless the_groups.include?(the_group)

    is_not_manager = !(player.is_manager_of?(the_group))
    if is_not_manager
      puts "#{player.user_id}, #{player.user_name} scorecard: #{player.scorecard_id} - #{Group.find(player.group_id).name}"
      
      player.has_no_role!(:member, the_group)
      GroupsUsers.leave_team(the_user, the_group)  
      Scorecard.set_archive_flag(the_user, the_group, true, false)
      Match.set_archive_flag(the_user, the_group, true, false)
      
    end
    puts "Archive user groups scorecards... B:  #{Time.zone.now}"
    puts
  end

  the_groups.each do |group|
    puts "#{group.name}"
    Scorecard.calculate_group_scorecard(group)
  end



end