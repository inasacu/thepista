class Match < ActiveRecord::Base
    
  acts_as_rateable
  
  belongs_to      :user
  belongs_to      :group
  belongs_to      :schedule
  belongs_to      :convocado, :class_name => "User", :foreign_key => "user_id"  
  belongs_to      :type,      :conditions => "table_type = 'Match'"
  # belongs_to      :invite,    :class_name => "Group", :foreign_key => "invite_id"
  
  belongs_to      :position,  
                  :class_name => "Type", 
                  :foreign_key => "position_id",                                 
                  :conditions => "types.table_type = 'User'"                  
  
  
  # validations  
  # validates_presence_of         :description
  # validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH
  
  # variables to access
  attr_accessible :name, :schedule_id, :user_id, :group_id, :invite_id, :group_score, :invite_score, :goals_scored
  attr_accessible :roster_position, :played, :available, :one_x_two, :user_x_two, :type_id, :status_at, :description
  attr_accessible :position_id, :technical, :physical
  
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
        
    the_match ||= "..."
    @schedule.forum.description = the_match.description
    Scorecard.calculate_group_scorecard(@schedule.group)
    Post.create_schedule_post(@schedule.forum, @schedule.forum.topics.first, user, the_match.description) if @schedule.played?
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

      self.create!(:name => schedule.concept, :description => schedule.description, 
                   :schedule_id => schedule.id, :group_id => schedule.group_id, 
                   :user_id => user.id, :available => user.available, 
                   :type_id => type_id, :position_id => position_id,
                   :played => schedule.played) if self.schedule_group_user_exists?(schedule, user)
    end
  end

  # def self.create_schedule_group_user_match(schedule, user)
  #   type_id = 3         # set to ausente
  #   position_id = 18    # set user position to center field 
  # 
  #   self.create!(:schedule_id => schedule.id, 
  #                :group_id => schedule.group.id, 
  #                :user_id => user.id, 
  #                :type_id => type_id, 
  #                :position_id => position_id) if self.schedule_group_user_exists?(schedule, user)
  # end

	# return ture if the schedule group user conbination is nil
   def self.schedule_group_user_exists?(schedule, user)
		find_by_schedule_id_and_group_id_and_user_id(schedule, schedule.group, user).nil?
	end 

  def self.log_activity_convocado(match)
    unless Activity.exists?(match, match.user)
      activity = Activity.create!(:item => match, :user => match.user)
      Feed.create!(:activity => activity, :user => match.user)
    end
  end   
end


