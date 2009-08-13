class Match < ActiveRecord::Base

  # # Authorization plugin
  # acts_as_authorizable 
  # acts_as_paranoid  
  # 
  # # validations 
  # #  validates_uniqueness_of   :name
  # #  validates_presence_of     :name,    :within => 3..100
  # 
  belongs_to      :user
  belongs_to      :group
  belongs_to      :schedule
  belongs_to      :convocado, :class_name => "User", :foreign_key => "user_id"
  
  belongs_to      :type,      :conditions => "table_type = 'Match'"
  belongs_to      :invite,    :class_name => "Group", :foreign_key => "invite_id"
  # 
  # # def total
  # #   players.inject(0) {|sum, n| 1 + sum}
  # # end
  # 
  # def is_invite?
  #   (!invite_id.nil? and invite_id > 0 and group_id != invite_id)
  # end
  # 
  # def team_name(schedule)
  #   (self.group_id > 0) ? schedule.home_group : schedule.away_group    
  # end
  # 
  # def win_loose_draw_label       
  #   return I18n.t(:game_tied)  if self.one_x_two == "X"  
  #   return I18n.t(:game_won)  if self.one_x_two == self.user_x_two  
  #   return I18n.t(:game_lost)  if self.one_x_two != self.user_x_two  
  # end
  # 
  # def self.user_assigned(scorecard)
  #     find(:first,
  #              :select => "count(*) as total", 
  #              :conditions =>["(group_id = ? or invite_id = ?) and user_id = ? and type_id = 1", scorecard.group_id, scorecard.group_id, scorecard.user_id])
  # end
  # 
  # def self.user_goals_scored(scorecard)
  #       find(:first,
  #                :select => "sum(goals_scored) as total", 
  #                :conditions =>["(group_id = ? or invite_id = ?) and user_id = ? and type_id = 1 and played = true", scorecard.group_id, scorecard.group_id, scorecard.user_id])
  #  end
  # 
  # def self.find_user_group_matches(user_id, group_id)
  #   find_by_sql(["select matches.id, matches.schedule_id, matches.user_id, matches.one_x_two, matches.user_x_two, matches.type_id, matches.played, " +
  #               "matches.group_id, matches.invite_id, matches.group_score, matches.invite_score, schedules.group_id " +
  #               "from matches, schedules " +
  #               "where matches.user_id = ? " +
  #               "and matches.type_id = 1 " +
  #               "and matches.played = true " +
  #               "and matches.schedule_id = schedules.id " +
  #               "and schedules.group_id = ? " +
  #               "order by schedules.starts_at desc", user_id, group_id])
  #   end
  # 
  #   # Return true if the match exist
  #   def self.exists?(schedule, user)
  #     find_by_schedule_id_and_user_id(schedule, user).nil?
  #   end
  # 
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
  # 
  # def self.set_archive_flag(user, group, flag)
  #   @matches = Match.find(:all, :conditions => ["user_id = ? and (group_id = ? or invite_id = ?)", user.id, group.id, group.id])
  #   @matches.each do |match|
  #     match.update_attribute(:archive, flag)
  #   end
  #   Scorecard.set_user_group_scorecard(user, group)
  # end
  # 
  # # assign availability to user in group selected and schedules not played
  # def self.create_match_for_player(groups, user_id)
  #   groups.each do |group|
  #     group.schedules.not_played.each do |schedule|
  #       group.users.available.each do |user|        
  #         if (user.id == user_id)          
  #           Match.create(:name => schedule.concept, :schedule_id => schedule.id,
  #           :user_id => user.id, :group_id => group.id) if self.exists?(schedule, user)
  #         end
  #       end      
  #     end
  #   end
  # end
  # 
  # def self.log_activity_convocado(match)
  #   unless Activity.exists?(match, match.user)
  #     activity = Activity.create!(:item => match, :user => match.user)
  #     Feed.create!(:activity => activity, :user => match.user)
  #   end
  # end 

	def create_schedule_group_user_match(schedule, group, user)
        self.create!(:schedule_id => schedule.id, :group_id => team.id, 
					 :user_id => user.id) if self.schedule_group_user_exists?(schedule, group, user)
	end

	# return ture if the schedule group user conbination is nil
   def self.schedule_group_user_exists?(schedule, group, user)
		find_by_schedule_id_and_group_id_and_user_id(schedule, group, user).nil?
	end 	
end

