class Match < ActiveRecord::Base
  
  belongs_to      :user
  belongs_to      :group
  belongs_to      :schedule
  belongs_to      :convocado, :class_name => "User", :foreign_key => "user_id"  
  belongs_to      :type,      :conditions => "table_type = 'Match'"
  # belongs_to      :invite,    :class_name => "Group", :foreign_key => "invite_id"
  
  # variables to access
  attr_accessible :name, :schedule_id, :user_id, :group_id, :invite_id, :group_score, :invite_score, :goals_scored
  attr_accessible :roster_position, :played, :available, :one_x_two, :user_x_two, :type_id, :status_at, :description
  # attr_accessible :match_attributes
      
  # 
  # # def total
  # #   players.inject(0) {|sum, n| 1 + sum}
  # # end
  
  def team_name(schedule)
    (self.group_id > 0) ? schedule.home_group : schedule.away_group 
    # schedule.home_group   
  end
  
  def win_loose_draw_label       
    return I18n.t(:game_tied)  if self.one_x_two == "X"  
    return I18n.t(:game_won)   if self.one_x_two == self.user_x_two  
    return I18n.t(:game_lost)  if self.one_x_two != self.user_x_two  
  end
  
  def self.user_assigned(scorecard)
      find(:first, :select => "count(*) as total", 
           :conditions =>["(group_id = #{scorecard.group_id} or invite_id = #{scorecard.group_id}) and user_id = #{scorecard.user_id} " +
                          "and type_id = 1 and archive = false"])
  end

  
  def self.user_played(scorecard)
      find(:first, :select => "count(*) as total", 
           :conditions =>["(group_id = #{scorecard.group_id} or invite_id = #{scorecard.group_id}) and user_id = #{scorecard.user_id} " +
                          "and type_id = 1 and played = true and archive = false"])
  end
 
  def self.user_goals_scored(scorecard)
        find(:first, :select => "sum(goals_scored) as total", 
             :conditions =>["(group_id = #{scorecard.group_id} or invite_id = #{scorecard.group_id}) and user_id = #{scorecard.user_id} " +
                            "and type_id = 1 and played = true and archive = false"])
  end
  
  def self.find_user_group_matches(user_id, group_id)
    find_by_sql(["select matches.id, matches.schedule_id, matches.user_id, matches.one_x_two, matches.user_x_two, matches.type_id, matches.played, " +
                "matches.group_id, matches.invite_id, matches.group_score, matches.invite_score, schedules.group_id " +
                "from matches, schedules " +
                "where matches.user_id = ? " +
                "and matches.type_id = 1 " +
                "and matches.played = true " +
                "and matches.schedule_id = schedules.id " +
                "and schedules.group_id = ? " +
                "order by schedules.starts_at desc", user_id, group_id])
    end
    

    def self.find_all_previous_schedules(user_id, group_id)
      find(:all, 
           :conditions => ["schedule_id not in (select max(id) as id from schedules where group_id = #{group_id} and played = true) " +
                           "and (group_id = #{group_id} or invite_id = #{group_id}) " +
                           "and user_id = #{user_id} and archive = false"],
           :order => "id")
    end
    
    def self.find_last_schedule(user_id, group_id)
      find(:all, 
           :conditions => ["schedule_id in (select max(id) as id from schedules where group_id = #{group_id} and played = true) " +
                           "and (group_id = #{group_id} or invite_id = #{group_id}) " +
                           "and user_id = #{user_id} and archive = false"],
           :order => "id")
    end
  
  #   def self.find_match_user_available(id)
  #     find_by_sql(["select matches.id as match_id, " +
  #       "matches.group_id, a.name as home_name, b.name as invite_name, " +
  #       "matches.group_score, matches.invite_score, " +
  #       "matches.user_id, users.name as name, " +
  #       "users.dorsal, users.email, users.phone, users.available, " +
  #       "availabilities.id as availability_id, availabilities.available, availabilities.reliable " +
  #       "from matches " +
  #       "left join groups a on a.id = matches.group_id " +
  #       "left join groups b on b.id = matches.invite_id " +
  #       "left join users on users.id = matches.user_id " +
  #       "left join availabilities on availabilities.schedule_id = matches.schedule_id " +
  #       "where matches.schedule_id = ?", id])
  #     end
  # 
  # def self.find_match_details(id)
  #   find_by_sql(["select schedules.id as schedule_id, schedules.concept, schedules.season, " +
  #     "schedules.starts_at, schedules.group_id, schedules.invite_id, " +
  #     "schedules.starts_at, schedules.played, schedules.group_id, schedules.invite_id, " +
  #     "schedules.location_id, schedules.sport_id, schedules.public, schedules.notes, " +
  #     "schedules.time_zone, matches.id as match_id, matches.name as match_name, " +      
  #     "locations.name as location_name, locations.url as location_url, " +
  #     "sports.name as activity_name, " +
  #     "a.name as home_name, b.name as invite_name " +
  #     "from schedules, matches, locations , sports, groups a, groups b " +
  #     "where matches.schedule_id = ? " + 
  #     "and matches.schedule_id = schedules.id " +
  #     "and schedules.location_id = locations.id " +
  #     "and schedules.sport_id = sports.id ", id])
  # end
  
  def self.set_archive_flag(user, group, flag)
    @matches = Match.find(:all, :conditions => ["user_id = ? and (group_id = ? or invite_id = ?)", user.id, group.id, group.id])
    @matches.each do |match|
      match.update_attribute(:archive, flag)
    end
    Scorecard.calculate_group_scorecard(group)
  end
  
  def self.update_match_details(the_match, user)
    @schedule = the_match.schedule    
    @schedule.played = (!the_match.group_score.nil? and !the_match.invite_score.nil?)
    @schedule.save!
    
    @schedule.matches.each do |match|
      match.group_score = the_match.group_score
      match.invite_score = the_match.invite_score
      match.description = the_match.description
      match.played = (match.type_id == 1 and @schedule.played)  

      # 1 == team one wins
      # x == teams draw
      # 2 == team two wins
      match.one_x_two = "" if (the_match.group_score.nil? or the_match.invite_score.nil?)
      match.one_x_two = "1" if (the_match.group_score.to_i > the_match.invite_score.to_i)
      match.one_x_two = "X" if (the_match.group_score.to_i == the_match.invite_score.to_i)
      match.one_x_two = "2" if (the_match.group_score.to_i < the_match.invite_score.to_i)

      # 1 == player is in team one
      # x == game tied, doesnt matter where player is
      # 2 == player is in team two      
      match.user_x_two = "1" if (match.group_id.to_i > 0 and match.invite_id.to_i == 0)
      match.user_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
      match.user_x_two = "2" if (match.group_id.to_i == 0 and match.invite_id.to_i > 0)

      match.save!  
    end       
    
    @schedule.forum.description = the_match.description
    
    Scorecard.calculate_group_scorecard(@schedule.group)
    Post.create_schedule_post(@schedule.forum, @schedule.forum.topics.first, user) if @schedule.played?
  end

  def self.save_matches(the_match, match_attributes)
    the_match.schedule.matches.each do |match|
      attributes = match_attributes[match.id.to_s]
      match.attributes = attributes if attributes
      match.save(false)
    end
  end
  
  # create a record in the match table for teammates in group team
  def self.create_schedule_match(schedule)
    schedule.group.users.each do |user|
      type_id = 3     # set to ausente

      self.create!(:name => schedule.concept, :schedule_id => schedule.id, :group_id => schedule.group_id, 
                  :user_id => user.id, :available => user.available, 
                  :type_id => type_id, :played => schedule.played) if self.schedule_group_user_exists?(schedule, user)
    end
  end

  def self.create_schedule_group_user_match(schedule, user)
    self.create!(:schedule_id => schedule.id, :group_id => schedule.group.id, 
    :user_id => user.id) if self.schedule_group_user_exists?(schedule, user)
  end

	# return ture if the schedule group user conbination is nil
   def self.schedule_group_user_exists?(schedule, user)
		find_by_schedule_id_and_group_id_and_user_id(schedule, schedule.group, user).nil?
	end 	
end

