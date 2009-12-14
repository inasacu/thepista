class Clash < ActiveRecord::Base
  
    belongs_to      :user
    belongs_to      :meet,        :dependent => :destroy
    belongs_to      :convocado,   :class_name => "User",                  :foreign_key => "user_id"  
    belongs_to      :type,        :conditions => "table_type = 'Clash'"

    belongs_to      :position,  
                    :class_name => "Type", 
                    :foreign_key => "position_id",                                 
                    :conditions => "types.table_type = 'User'"                  

    # validations  
    validates_numericality_of :technical,    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5
    validates_numericality_of :physical,     :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5

    # variables to access
    attr_accessible :name, :meet_id, :user_id, :user_score
    attr_accessible :played, :one_x_two, :user_x_two, :type_id, :status_at, :description
    attr_accessible :position_id, :technical, :physical

    before_create   :format_description

    def position_name
      I18n.t(self.position.name)
    end    

    # def win_loose_draw_label       
    #   return I18n.t(:game_tied)  if self.one_x_two == "X"  
    #   return I18n.t(:game_won)   if self.one_x_two == self.user_x_two  
    #   return I18n.t(:game_lost)  if self.one_x_two != self.user_x_two  
    # end

    # def self.user_assigned(standing)
    #     find(:first, :select => "count(*) as total", 
    #          :conditions =>["(meet_id = #{standing.meet_id} or invite_id = #{standing.meet_id}) and user_id = #{standing.user_id} " +
    #                         "and type_id = 1 and archive = false"])
    # end


    # def self.user_played(standing)
    #     find(:first, :select => "count(*) as total", 
    #          :conditions =>["(meet_id = #{standing.meet_id} or invite_id = #{standing.meet_id}) and user_id = #{standing.user_id} " +
    #                         "and type_id = 1 and played = true and archive = false"])
    # end

    # def self.user_goals_scored(standing)
    #       find(:first, :select => "sum(goals_scored) as total", 
    #            :conditions =>["(meet_id = #{standing.meet_id} or invite_id = #{standing.meet_id}) and user_id = #{standing.user_id} " +
    #                           "and type_id = 1 and played = true and archive = false"])
    # end

    # def self.find_user_round_clashes(user_id, meet_id)
    #   find_by_sql(["select clashes.id, clashes.meet_id, clashes.user_id, clashes.one_x_two, clashes.user_x_two, clashes.type_id, clashes.played, " +
    #               "clashes.meet_id, clashes.invite_id, clashes.user_score, clashes.invite_score, meets.meet_id " +
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
    #   Standing.calculate_user_standing(round)
    # end

    def self.update_clash_details(meet)       
      is_played ||= false
      tie_game ||= true
           
      clash_id, ranking, past_points, last = 0, 0, 0, 0        
      meet.clashes.each do |clash|
        points = clash.user_score        
        if clash_id != clash.id 
          clash_id, ranking,  past_points, last = clash.id, 0, 0, 1
        end 

        if (past_points == points) 
          last += 1          
        else
          ranking += last
          last = 1          
        end
        
        tie_game = !tie_game if (ranking == 1)
        
        past_points = points  
        clash.one_x_two = ranking
        clash.user_x_two = 1
        clash.description = meet.description
        clash.played = !clash.user_score.nil? 
        clash.save! 
        
        is_played = true unless clash.user_score.nil?       
      end   
      
      # update for draw game
      if tie_game
        meet.clashes.each do  |clash|
          clash.user_x_two = 99999
          clash.save!
        end
      end
      
      # if any clashes has a user score then game is played
      meet.played = is_played
      meet.save!

      Standing.calculate_round_standing(meet.round)
      Standing.update_round_user_ranking(meet.round)  
      # Post.create_meet_post(@meet.forum, @meet.forum.topics.first, user, the_clash.description) if @meet.played?
    end

    def self.save_clashes(meet, clash_attributes)
      meet.clashes.each do |clash|
        attributes = clash_attributes[clash.id.to_s]
        clash.attributes = attributes if attributes
        clash.save(false)
      end
    end

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
  	
  	def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def self.log_activity_convocado(clash)
      unless Activity.exists?(clash, clash.user)
        activity = Activity.create!(:item => clash, :user => clash.user)
        Feed.create!(:activity => activity, :user => clash.user)
      end
    end   
  end


