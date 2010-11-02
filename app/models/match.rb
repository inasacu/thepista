class Match < ActiveRecord::Base
          
  belongs_to      :user
  belongs_to      :group
  belongs_to      :schedule
  belongs_to      :convocado, :class_name => "User", :foreign_key => "user_id"  
  belongs_to      :type,      :conditions => "table_type = 'Match'"
  
  belongs_to      :position,  
                  :class_name => "Type", 
                  :foreign_key => "position_id",                                 
                  :conditions => "types.table_type = 'User'"                  
    
  # validations  
  validates_numericality_of :technical,    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5
  validates_numericality_of :physical,     :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH
  
  # variables to access
  attr_accessible :name, :schedule_id, :user_id, :group_id, :invite_id, :group_score, :invite_score
  attr_accessible :roster_position, :played, :available, :one_x_two, :user_x_two, :type_id, :status_at, :description
  attr_accessible :position_id, :technical, :physical
  attr_accessible :goals_scored, :game_started, :field_goal_attempt, :field_goal_made, :free_throw_attempt, :free_throw_made
  attr_accessible :three_point_attempt, :three_point_made, :rebounds, :rebounds_defense, :rebounds_offense 
  attr_accessible :minutes_played, :assists, :steals, :blocks, :turnovers, :personal_fouls


  before_create   :format_description
  
  # method section
  def self.latest_items(items, user)
    find(:all, :select => "DISTINCT matches.id, matches.user_id, matches.schedule_id, matches.status_at as created_at", 
         :joins => "left join groups_users on groups_users.user_id = matches.user_id",    
         :conditions => ["groups_users.group_id in (?) and matches.status_at >= ?", user.groups, LAST_24_HOURS]).each do |item| 
      items << item
    end
    return items 
  end
  
  def position_name
    I18n.t(self.position.name)
  end
  
  def team_name(schedule)
    (self.group_id > 0) ? schedule.home_group : schedule.away_group 
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
         :conditions => ["schedule_id in (" +
                        "select id from schedules where group_id = #{group_id} and played = true and id not in " +
                        "(select max(id) as id from schedules where group_id = #{group_id} and played = true)) " +
                         "and (group_id = #{group_id} or invite_id = #{group_id}) " +
                         "and user_id = #{user_id} and type_id = 1 and archive = false"],
         :order => "id")
  end
    
  def self.find_all_schedules(user_id, group_id)
    find(:all, 
         :conditions => ["schedule_id in (select id from schedules where group_id = #{group_id} and played = true) " +
                         "and (group_id = #{group_id} or invite_id = #{group_id}) " +
                         "and user_id = #{user_id} and type_id = 1 and archive = false"],
         :order => "id")
  end
  
  def self.set_archive_flag(user, group, flag)
    @matches = Match.find(:all, :conditions => ["user_id = ? and (group_id = ? or invite_id = ?)", user.id, group.id, group.id])
    @matches.each do |match|
      match.update_attribute(:archive, flag)
    end
    Scorecard.send_later(:calculate_group_scorecard, group)
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
        
    the_match ||= "..."
    @schedule.forum.description = the_match.description
    Scorecard.send_later(:calculate_group_scorecard, @schedule.group)
    # Post.create_topic_post(@schedule.forum, @schedule.forum.topics.first, user, the_match.description) if @schedule.played?
    @schedule.forum.comments.create(:body => the_match.description, :user => user)  if @schedule.played?   
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
      type_id = 3         # set to ausente
      position_id = 18    # set user position to center field 
      technical = 3       # set user technical to default value
      physical = 3        # set user physical to default value

      @previous_match = Match.find(:first, 
            :conditions => ["id = (select max(id) from matches where (group_id = ? or invite_id = ?) and user_id = ?) ", schedule.group_id, schedule.group_id, user.id])    
      unless @previous_match.nil?
        position_id = @previous_match.position_id
        technical = @previous_match.technical
        physical = @previous_match.physical
      end

      self.create!(:name => schedule.concept, :description => schedule.description, 
                   :schedule_id => schedule.id, :group_id => schedule.group_id, 
                   :user_id => user.id, :available => user.available, 
                   :type_id => type_id, :position_id => position_id, :technical => technical, :physical => physical,
                   :played => schedule.played) if self.schedule_user_exists?(schedule, user)
    end
  end
  
  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

	# return true if the schedule group user conbination is nil
  def self.schedule_user_exists?(schedule, user)
    find_by_schedule_id_and_user_id(schedule, user).nil?    
  end 

  def self.log_activity_convocado(match)
    if Activity.exists?(match, match.user)
      activity = Activity.create!(:item => match, :user => match.user)
    end
  end   
  
  def self.find_score(schedule)
    find(:first, :conditions => ["schedule_id = ? and group_score is not null and invite_score is not null", schedule])
  end
end


