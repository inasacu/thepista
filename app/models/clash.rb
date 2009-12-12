class Clash < ActiveRecord::Base
  
    belongs_to      :user
    belongs_to      :meet,     :dependent => :destroy
    
    belongs_to      :convocado, :class_name => "User", :foreign_key => "user_id"  

    # variables to access
    attr_accessible :name, :meet_id, :user_id, :user_score
    attr_accessible :played, :one_x_two, :user_x_two, :type_id, :status_at

    # def team_name(meet)
    #   (self.meet_id > 0) ? meet.home_round : meet.away_round 
    # end

    # def win_loose_draw_label       
    #   return I18n.t(:game_tied)  if self.one_x_two == "X"  
    #   return I18n.t(:game_won)   if self.one_x_two == self.user_x_two  
    #   return I18n.t(:game_lost)  if self.one_x_two != self.user_x_two  
    # end

    # def self.user_assigned(scorecard)
    #     find(:first, :select => "count(*) as total", 
    #          :conditions =>["(meet_id = #{scorecard.meet_id} or invite_id = #{scorecard.meet_id}) and user_id = #{scorecard.user_id} " +
    #                         "and type_id = 1 and archive = false"])
    # end


    # def self.user_played(scorecard)
    #     find(:first, :select => "count(*) as total", 
    #          :conditions =>["(meet_id = #{scorecard.meet_id} or invite_id = #{scorecard.meet_id}) and user_id = #{scorecard.user_id} " +
    #                         "and type_id = 1 and played = true and archive = false"])
    # end

    # def self.user_goals_scored(scorecard)
    #       find(:first, :select => "sum(goals_scored) as total", 
    #            :conditions =>["(meet_id = #{scorecard.meet_id} or invite_id = #{scorecard.meet_id}) and user_id = #{scorecard.user_id} " +
    #                           "and type_id = 1 and played = true and archive = false"])
    # end

    # def self.find_user_round_clashes(user_id, meet_id)
    #   find_by_sql(["select clashes.id, clashes.meet_id, clashes.user_id, clashes.one_x_two, clashes.user_x_two, clashes.type_id, clashes.played, " +
    #               "clashes.meet_id, clashes.invite_id, clashes.round_score, clashes.invite_score, meets.meet_id " +
    #               "from clashes, meets " +
    #               "where clashes.user_id = ? " +
    #               "and clashes.type_id = 1 " +
    #               "and clashes.played = true " +
    #               "and clashes.meet_id = meets.id " +
    #               "and meets.meet_id = ? " +
    #               "order by meets.starts_at desc", user_id, meet_id])
    # end

    # def self.find_all_previous_meets(user_id, meet_id)
    #   find(:all, 
    #        :conditions => ["meet_id in (" +
    #                       "select id from meets where meet_id = #{meet_id} and played = true and id not in " +
    #                       "(select max(id) as id from meets where meet_id = #{meet_id} and played = true)) " +
    #                        "and (meet_id = #{meet_id} or invite_id = #{meet_id}) " +
    #                        "and user_id = #{user_id} and type_id = 1 and archive = false"],
    #        :order => "id")
    # end

    # def self.find_all_meets(user_id, meet_id)
    #   find(:all, 
    #        :conditions => ["meet_id in (select id from meets where meet_id = #{meet_id} and played = true) " +
    #                        "and (meet_id = #{meet_id} or invite_id = #{meet_id}) " +
    #                        "and user_id = #{user_id} and type_id = 1 and archive = false"],
    #        :order => "id")
    # end

    # def self.set_archive_flag(user, round, flag)
    #   @clashes = Clash.find(:all, :conditions => ["user_id = ? and (meet_id = ? or invite_id = ?)", user.id, round.id, round.id])
    #   @clashes.each do |clash|
    #     clash.update_attribute(:archive, flag)
    #   end
    #   Standing.calculate_round_scorecard(round)
    # end

    # def self.update_clash_details(the_clash, user)
    #   @meet = the_clash.meet    
    #   @meet.played = (!the_clash.round_score.nil? and !the_clash.invite_score.nil?)
    #   @meet.save!
    # 
    #   @meet.clashes.each do |clash|
    #     clash.round_score = the_clash.round_score
    #     clash.invite_score = the_clash.invite_score
    #     clash.description = the_clash.description
    #     clash.played = (clash.type_id == 1 and @meet.played)  
    # 
    #     # 1 == team one wins
    #     # x == teams draw
    #     # 2 == team two wins
    #     clash.one_x_two = "" if (the_clash.round_score.nil? or the_clash.invite_score.nil?)
    #     clash.one_x_two = "1" if (the_clash.round_score.to_i > the_clash.invite_score.to_i)
    #     clash.one_x_two = "X" if (the_clash.round_score.to_i == the_clash.invite_score.to_i)
    #     clash.one_x_two = "2" if (the_clash.round_score.to_i < the_clash.invite_score.to_i)
    # 
    #     # 1 == player is in team one
    #     # x == game tied, doesnt matter where player is
    #     # 2 == player is in team two      
    #     clash.user_x_two = "1" if (clash.meet_id.to_i > 0 and clash.invite_id.to_i == 0)
    #     clash.user_x_two = "X" if (clash.round_score.to_i == clash.invite_score.to_i)
    #     clash.user_x_two = "2" if (clash.meet_id.to_i == 0 and clash.invite_id.to_i > 0)
    # 
    #     clash.save!  
    #   end       
    # 
    #   the_clash ||= "..."
    #   @meet.forum.description = the_clash.description
    #   Standing.calculate_round_scorecard(@meet.round)
    #   Post.create_meet_post(@meet.forum, @meet.forum.topics.first, user, the_clash.description) if @meet.played?
    # end

    # def self.save_clashes(the_clash, clash_attributes)
    #   the_clash.meet.clashes.each do |clash|
    #     attributes = clash_attributes[clash.id.to_s]
    #     clash.attributes = attributes if attributes
    #     clash.save(false)
    #   end
    # end

    # create a record in the clash table for teammates in round team
    def self.create_meet_clash(meet, user)
      type_id = 1         # set to convocado
      position_id = 18    # set user position to center field create_meet_clash
      technical = 3       # set user technical to default value
      physical = 3        # set user physical to default value

      @previous_clash = Clash.find(:first, 
            :conditions => ["id = (select max(id) from clashes where meet_id = ? and user_id = ?) ", meet.id, user.id])    
      unless @previous_clash.nil?
        position_id = @previous_clash.position_id
        technical = @previous_clash.technical
        physical = @previous_clash.physical
      end

      self.create!(:name => meet.concept, :meet_id => meet.id, :user_id => user.id,  
      :type_id => type_id, :position_id => position_id, :technical => technical, :physical => physical,
      :played => meet.played) if self.meet_user_exists?(meet, user)
    end

  	# return ture if the meet round user conbination is nil
     def self.meet_user_exists?(meet, user)
  		find_by_meet_id_and_user_id(meet, user).nil?
  	end 

    # def self.log_activity_convocado(clash)
    #   unless Activity.exists?(clash, clash.user)
    #     activity = Activity.create!(:item => clash, :user => clash.user)
    #     Feed.create!(:activity => activity, :user => clash.user)
    #   end
    # end   
  end


