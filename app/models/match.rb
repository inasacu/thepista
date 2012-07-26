# TABLE "matches"
# t.integer  "schedule_id"
# t.integer  "user_id"
# t.integer  "group_id"
# t.integer  "invite_id"                                                           
# t.integer  "group_score"
# t.integer  "invite_score"
# t.integer  "goals_scored"                                                        
# t.integer  "roster_position"                                                     
# t.boolean  "played"                                                              
# t.string   "one_x_two"                
# t.string   "user_x_two"               
# t.integer  "type_id"
# t.datetime "status_at"                                                           
# t.boolean  "archive"                                                             
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "rebounds_offense"                                                    
# t.decimal  "rating_average_technical"               
# t.decimal  "rating_average_physical"                
# t.float    "initial_mean"                                                        
# t.float    "initial_deviation"                                                   
# t.float    "final_mean"                                                          
# t.float    "final_deviation"                                                     
# t.integer  "game_number"                                                         
# t.string   "block_token"

require "base64"

class Match < ActiveRecord::Base
  
  belongs_to      :user
  belongs_to      :group
  belongs_to      :schedule
  belongs_to      :convocado, 		:class_name => "User", :foreign_key => "user_id"  
  belongs_to      :team_change, 	:class_name => "User", :foreign_key => "change_id"

  belongs_to      :type,      	:conditions => "table_type = 'Match'"
  
  # variables to access
	attr_accessible :schedule_id, :user_id, :group_id, :invite_id, :group_score, :invite_score
	attr_accessible :roster_position, :played, :one_x_two, :user_x_two, :type_id, :status_at, :block_token
	attr_accessible :goals_scored, :archive, :slug, :change_id

	# attr_accessible :matches_attributes
	#   accepts_nested_attributes_for :matches
	  
  # method section
  def match_name
    "#{group.name} #{name} #{I18n.t(:match)}"
  end
  
  def self.latest_items(items, user)
    find(:all, :select => "distinct matches.id, matches.user_id, matches.schedule_id, matches.type_id, types.name as type_name, matches.status_at as created_at", 
         :joins => "left join groups_users on groups_users.user_id = matches.user_id left join types on types.id = matches.type_id left join schedules on schedules.id = matches.schedule_id",    
         :conditions => ["schedules.played = false and groups_users.group_id in (?) and 
              age(matches.status_at, matches.created_at) > '00:00:00' and matches.status_at != matches.created_at and matches.status_at >= ?", user.groups, LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end

  # users who set to ausente w/n 24 hours of match
  def self.last_minute_items(items, user)
    find(:all, :select => "distinct matches.id, matches.user_id, matches.schedule_id, matches.type_id, types.name as type_name, matches.status_at as created_at", 
         :joins => "left join groups_users on groups_users.user_id = matches.user_id left join types on types.id = matches.type_id left join schedules on schedules.id = matches.schedule_id",    
         :conditions => ["schedules.archive = false and matches.type_id = 3 and schedules.played = true and groups_users.group_id in (?) and 
              age(matches.status_at, matches.created_at) > '00:00:00' and 
              matches.status_at != matches.created_at and matches.status_at >= schedules.starts_at - INTERVAL '1 days' 
              and matches.status_at >= ?", user.groups, LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end
  
  def self.last_games_played(user)
    find(:all, :select => "schedules.group_id",
         :joins => "left join schedules on schedules.id = matches.schedule_id",
         :conditions => ["matches.user_id = ? and matches.type_id = 1 and schedules.played = true", user],
         :order => "schedules.starts_at DESC", :limit => GAMES_PLAYED)
  end
  
  def self.get_rating_average(match, group)
    find(:first,	:select => "max(matches.rating_average_technical) as rating_average_technical, max(matches.rating_average_physical) as rating_average_physical",
          :joins => "left join schedules on schedules.id = matches.schedule_id",
          :conditions => ["matches.user_id = ? and schedules.group_id = ?", match.user_id, group.id])
  end
  
  def self.get_previous_user_match(match, schedule_number, group) 
    find(:first, :select => "matches.*", 
          :conditions => ["user_id = ? and type_id = 1 and game_number > 0 and game_number < ? and archive = false and schedule_id in (select id from schedules where schedules.group_id = ?)", match.user_id, schedule_number, group],
          :order => "game_number DESC")
  end
		
  def self.get_user_group_skill(user, group)
    find(:first, :select => "matches.*",
         :joins => "left join schedules on schedules.id = matches.schedule_id",
         :conditions => ["schedules.group_id = ? and schedules.played = true and matches.user_id = ? and matches.archive = false", group, user],
         :order => "matches.game_number DESC")
  end
		
	def self.get_matches_users(schedule)
	  find(:all, :joins   => "LEFT JOIN users on matches.user_id = users.id",
    :conditions => ["schedule_id = ? and matches.archive = false and users.archive = false", schedule],
    :order => "users.name")
  end
  
  
  def self.get_match_type
    return Type.where("id in (1, 2, 3, 4)").order("id")
  end
  
  def position_name
    I18n.t(self.position.name)
  end
  
  def type_name
    I18n.t(self.type.name)
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
    
  def self.find_all_schedules(user_id, group_id, previous_matches=true)
    matches = []
    all_matches = Match.find(:all, :joins => "LEFT JOIN schedules on matches.schedule_id = schedules.id",
                                   :conditions => ["schedules.group_id = #{group_id} and schedules.played = true and schedules.archive = false and
                                                    matches.user_id = #{user_id} and matches.archive = false"], :order => "schedules.starts_at DESC")

      first = previous_matches        # remove previous match
      
      all_matches.each do |match| 
        unless first
          matches << match if match.type_id == 1
        end
        first = false
      end	

      return matches
    end
    
  def self.user_upcoming_match(user)
    find(:all,
         :conditions => ["matches.user_id = ? and matches.schedule_id in (select id from schedules where schedules.starts_at >= ? and schedules.ends_at <= ?) and 
                          matches.played = false and matches.archive = false", user, LAST_24_HOURS, NEXT_WEEK])
  end
  
  
  def self.set_archive_flag(user, group, flag)
    @matches = Match.find(:all, :conditions => ["user_id = ? and (group_id = ? or invite_id = ?)", user.id, group.id, group.id])
    @matches.each do |match|
      match.update_attribute(:archive, flag)
    end
    Scorecard.delay.calculate_group_scorecard(group)
  end
  
  def self.update_match_details(the_match, user)
    @schedule = the_match.schedule    
    @schedule.played = (!the_match.group_score.nil? and !the_match.invite_score.nil?)
    @schedule.save!
    
    @schedule.matches.each do |match|
      match.group_score = the_match.group_score
      match.invite_score = the_match.invite_score
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
      
      match.block_token = '' if @schedule.played

      match.save!  
    end       
    Scorecard.delay.calculate_group_scorecard(@schedule.group)
  end

  def self.save_matches(the_match, matches_attributes)
    the_match.schedule.matches.each do |match|
      attributes = matches_attributes[match.id.to_s]
      match.attributes = attributes if attributes
      match.save!
    end
  end
  
  # create a record in the match table for teammates in group team
  def self.create_schedule_match(schedule)
    schedule.group.users.each do |user|
      type_id = 3         # set to ausente
      
      # assign unique user id and start_date code for changing status through email
      the_encode = "#{rand(36**8).to_s(36)}#{schedule.id}#{rand(36**8).to_s(36)}"
      block_token  = Base64::encode64(the_encode)

      self.create!(:status_at => Time.zone.now, :schedule_id => schedule.id, :group_id => schedule.group_id, :user_id => user.id,  
                   :type_id => type_id, :played => schedule.played, :block_token => block_token) if Match.schedule_user_exists?(schedule, user)
    end
  end
  
  def self.set_default_skill(group)
    the_initial_standard_deviation = (InitialMean / K_FACTOR).to_f
    
    sql = %(UPDATE matches set initial_mean = 0.0, initial_deviation = 0.0, final_mean = 0.0, final_deviation = 0.0, game_number = 0
             where archive = false and schedule_id in (select id from schedules where schedules.played = true and schedules.group_id = #{group.id}))
    ActiveRecord::Base.connection.execute(sql)
    

    # set all matches where user has played to corresponding correct game number played per player
    all_user_played_matches = Match.find(:all, :select => "matches.*",
    :joins => "left join schedules on schedules.id = matches.schedule_id",
    :conditions => ["schedules.group_id = ? and schedules.played = true and matches.type_id = 1 and schedules.archive = false and matches.archive = false", group],
    :order => "matches.user_id, schedules.starts_at")
    user_id = 0
    game_number = 0

    all_user_played_matches.each do |match|

      unless user_id == match.user_id
        user_id = match.user_id
        game_number = 0
      end  
      game_number += 1

      if game_number != match.game_number or game_number.nil?
        if game_number == 1
          match.initial_mean = InitialMean
          match.initial_deviation = the_initial_standard_deviation
          match.game_number = game_number
          match.save!
        else
          match.initial_mean = 0
          match.initial_deviation = 0
          match.game_number = game_number
          match.save!
        end
      end

    end
  end
  
  def self.set_true_skill(group)
    the_initial_standard_deviation = (InitialMean / K_FACTOR).to_f
       
    home_rating = []
    away_rating = []
    the_match_home = []  
    home_match = []
    away_match = []

    the_schedules_played = Schedule.find(:all, :conditions => ["group_id = ? and played = true and archive = false", group], :order => "starts_at")
    the_schedules_played.each do |schedule|

      home_score, away_score = 0, 0
      play_activity = 0.0

      schedule_number = Schedule.schedule_number(schedule)   

      the_matches = Match.find(:all, :select => "matches.*",
      :joins => "left join schedules on schedules.id = matches.schedule_id",
      :conditions => ["schedules.id = ? and schedules.played = true and matches.type_id = 1 and schedules.archive = false and matches.archive = false", schedule],
      :order => "matches.group_id DESC")

      the_matches.each do |match|

        previous_final_mean = InitialMean
        previous_final_deviation = the_initial_standard_deviation

        mean_skill = InitialMean
        skill_deviation = the_initial_standard_deviation

        is_second_team = !(match.group_id > 0)    
        home_score, away_score = match.group_score, match.invite_score
        game_number = 1

        # get users previous games skill levels
        if schedule_number > 1
          previous_user_match = Match.get_previous_user_match(match, schedule_number, group) 
          unless previous_user_match.nil?

            if  previous_user_match.game_number > 0 and previous_user_match.final_deviation > 0.0                    
              mean_skill = previous_user_match.final_mean 
              skill_deviation = previous_user_match.final_deviation            
            end          
            game_number  = previous_user_match.game_number
          end        
        end

        play_activity = game_number.to_f / schedule_number.to_f     

        if is_second_team
          away_rating << Rating.new(mean_skill, skill_deviation, play_activity) 
          away_match << match
        else
          home_rating << Rating.new(mean_skill, skill_deviation, play_activity) 
          home_match << match
        end    
      end

      if (home_score.to_i > away_score.to_i)
        # puts "home_rating"
        home_match.each {|home| the_match_home << home}
        away_match.each {|away| the_match_home << away}
      elsif (home_score.to_i < away_score.to_i)
        # puts "away_rating"
        away_match.each {|away| the_match_home << away}
        home_match.each {|home| the_match_home << home}
      else 
        # puts "a tie" 
        home_match.each {|home| the_match_home << home}
        away_match.each {|away| the_match_home << away}
      end

      the_first, the_second = 1, 2 
      the_first, the_second = 1, 1  if (home_score.to_i == away_score.to_i)

      graph = FactorGraph.new([home_rating, away_rating], [the_first, the_second]) unless (home_score.to_i < away_score.to_i)
      graph = FactorGraph.new([away_rating, home_rating], [the_first, the_second]) if (home_score.to_i < away_score.to_i)
      graph.update_skills

      jornada = 0
      index = 0
      graph.teams.each do |teams|
        
        teams.each do |player| 
          the_match_home[index].final_mean = player.mean
          the_match_home[index].final_deviation = player.deviation
          the_match_home[index].save 

          if the_match_home[index].game_number > 1       
            the_previous_user_match = Match.get_previous_user_match(the_match_home[index], the_match_home[index].game_number, group) 
            unless the_previous_user_match.nil?    
              the_match_home[index].initial_mean = the_previous_user_match.final_mean 
              the_match_home[index].initial_deviation = the_previous_user_match.final_deviation 
              the_match_home[index].save
            end
          end

          index +=1     
        end     
      end

      home_rating.clear
      away_rating.clear
      the_match_home.clear
      home_match.clear
      away_match.clear
    end
  end

	# return true if the schedule group user conbination is nil
  def self.schedule_user_exists?(schedule, user)
    find_by_schedule_id_and_user_id(schedule, user).nil?    
  end 
  
  def self.find_score(schedule)
    find(:first, :conditions => ["schedule_id = ? and group_score is not null and invite_score is not null", schedule])
  end
end


