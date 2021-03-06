# == Schema Information
#
# Table name: cups
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  starts_at           :datetime
#  ends_at             :datetime
#  deadline_at         :datetime
#  time_zone           :string(255)
#  sport_id            :integer
#  group_stage         :boolean          default(TRUE)
#  group_stage_single  :boolean          default(TRUE)
#  second_stage_single :boolean          default(TRUE)
#  final_stage_single  :boolean          default(TRUE)
#  group_stage_advance :integer          default(16)
#  points_for_win      :integer          default(3)
#  points_for_draw     :integer          default(1)
#  points_for_lose     :integer          default(0)
#  description         :text
#  conditions          :text
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer
#  photo_updated_at    :datetime
#  archive             :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  official            :boolean          default(FALSE)
#  club                :boolean          default(TRUE)
#  slug                :string(255)
#  venue_id            :integer          default(1)
#  public              :boolean          default(TRUE)
#  player_limit        :integer          default(50)
#  city_id             :integer          default(1)
#

class Cup < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged

  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/s3.yml",
  :url => "/assets/cups/:id/:style.:extension",
  :path => ":assets/cups/:id/:style.:extension",
  :default_url => IMAGE_GROUP_AVATAR  

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
  validates_attachment_size         :photo, :less_than => 5.megabytes

  # validations 
  validates_uniqueness_of   :name,    :case_sensitive => false
  
  validates_presence_of     :name
  validates_presence_of     :description
  validates_presence_of     :sport_id
	validates_presence_of			:venue_id
  
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
      
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
    
  validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100

  # variables to access
  attr_accessible :name, :points_for_win, :points_for_draw, :points_for_lose, :official, :club
  attr_accessible :time_zone, :sport_id, :description, :conditions, :photo
  attr_accessible :starts_at, :ends_at, :deadline_at, :archive, :player_limit
  attr_accessible :group_stage_advance, :group_stage, :group_stage_single, :second_stage_single, :final_stage_single, :slug
	attr_accessible	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :venue_id, :city_id

  has_and_belongs_to_many :escuadras,     :join_table => "cups_escuadras",   :order => "name"
  has_many                :games
  has_many                :standings,     :order => "points DESC, ranking"
  has_many                :challenges, 		:conditions => "challenges.archive = false"
  belongs_to              :sport
	belongs_to							:venue
  
  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Cup'"]

  belongs_to    :sport   
  belongs_to    :city

  before_create :format_description #, :format_conditions
  before_update :format_description #, :format_conditions

	attr_accessor 	:starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time
  before_update   :get_starts_at, :get_ends_at
  
  # add some callbacks, after_initialize :get_starts_at # convert db format to accessors
	before_create	:get_starts_at, :get_ends_at
  before_validation :get_starts_at, :get_ends_at, :set_starts_at, :set_ends_at 

	def get_starts_at
		self.starts_at ||= Time.now  
		self.starts_at_date ||= self.starts_at.to_date.to_s(:db) 
		self.starts_at_time ||= "#{'%02d' % self.starts_at.hour}:#{'%02d' % self.starts_at.min}" 
	end

	def set_starts_at
		self.starts_at = "#{self.starts_at_date} #{self.starts_at_time}:00" 
	end

	def get_ends_at
		self.ends_at ||= Time.now  
		self.ends_at_date ||= self.ends_at.to_date.to_s(:db) 
		self.ends_at_time ||= "#{'%02d' % self.ends_at.hour}:#{'%02d' % self.ends_at.min}" 
	end

	def set_ends_at
		self.ends_at = "#{self.ends_at_date} #{self.ends_at_time}:00" 
	end


  def all_the_managers
    ids = []
    self.the_managers.each {|user| ids << user.user_id }
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def the_escuadras
    return self.escuadras.collect {|p| [ p.name, p.id ] }
  end

  def avatar
    self.photo.url
  end

  def mediam
    self.photo.url(:medium)
  end

  def thumbnail
    self.photo.url(:thumb)
  end

  def icon
    self.photo.url(:icon)
  end
  
  def has_game?
    self.games.count > 0
  end
  
  def is_futbol?
   	# sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end
  
  def is_basket?
   	# sports related to basket
    return [7].include?(self.sport_id)
  end
  
  def self.current_cups(page = 1)
    self.where("archive = false").page(page).order('starts_at')
  end

  # def self.previous_cups(page = 1)
  #   self.where("ends_at < ? and archive = false", Time.zone.now).page(page).order('starts_at')
  # end
  
  def self.latest_items(items, has_values)
    find(:all, :conditions => ["created_at >= ?", LAST_WEEK], :order => "id desc").each do |item| 
      items << item
      has_values = true
    end
    return items
  end
  
  def self.has_official_cup?
    !(find(:first, :conditions => "archive = false and official = true").nil?)
  end
   
  def has_standing    
    @standing = Cup.find(:first, :select => "count(*) as total", 
                     :joins => "left join standings on standings.cup_id = cups.id", 
                     :conditions => ["standings.cup_id = ? and standings.item_type = 'Escuadra'", self])
    
     if @standing.nil? or @standing.blank? 
       return false
     elsif @standing.total.to_i == 0
       return false
     end      
     return true    
   end
  
  def games_played
    the_played = 0
    self.games.each {|game| the_played += 1 if game.played}
    return the_played
  end

  def create_cup_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)
  end
  
  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end
  
  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end

	def self.upcoming_cups(hide_time)
		with_scope(:find => where(:starts_at => MAJOR_EVENT_TWO_MONTHS, :archive => false).order("starts_at")) do
			if hide_time.nil?
				self.all()
			else
				self.where("starts_at >= ?", hide_time)
			end
		end
	end
	
  
  # group stage games
  def create_group_stage(teams)
    
    # return unless self.group_stage    
    teams.reverse!

    # Hash of hashes to keep track of matchups already used.
    played = Hash[ * teams.map { |t| [t, {}] }.flatten ]

    # Initially generate the cup as a list of games.
    games = []
    return [] unless set_game(0, games, played, teams, nil)

    # Convert the list into cup rounds.
    rounds = []    
    rounds.push games.slice!(0, teams.size / 2) while games.size > 0             
    rounds
  end

  # create games for group stage
  def set_game(i, games, played, teams, rem)
    # Convenience vars: N of teams and total N of games.
    nt  = teams.size
    ng  = (nt - 1) * nt / 2

    # If we are working on the first game of a round,
    # reset rem (the teams remaining to be scheduled in
    # the round) to the full list of teams.
    rem = Array.new(teams) if i % (nt / 2) == 0

    # Remove the top-seeded team from rem.
    top = rem.sort_by { |tt| teams.index(tt) }.pop
    rem.delete(top)

    # Find the opponent for the top-seeded team.
    rem.each_with_index do |opp, j|
      # If top and opp haven't already been paired, schedule the matchup.
      next if played[top][opp]
      games[i] = [ top, opp ]

      played[top][opp] = true

      # create the round
      create_group_stage_game(games[i])    

      # Create a new list of remaining teams, removing opp
      # and putting rejected opponents at the end of the list.
      rem_new = [ rem[j + 1 .. rem.size - 1], rem[0, j] ].compact.flatten

      # Method has succeeded if we have scheduled the last game
      # or if all subsequent calls succeed.
      return true if i + 1 == ng
      return true if set_game(i + 1, games, played, teams, rem_new)

      # The matchup leads down a bad path. Unschedule the game
      # and proceed to the next opponent.
      played[top][opp] = false
      destroy_group_stage_game(games[i])  
      # puts " *** removed *** "  
    end

    return false
  end
  
  # create games for cup round in group stage
  def create_group_stage_game(game)    
    
    if Game.cup_home_away_exist?(self, game[0], game[1]) 
      
      standing = Standing.find(:first, :conditions => ["cup_id = ? and item_id = ? and item_type = ?", self.id, game[0].id, game[0].class.to_s])

      last_game = get_the_last_game      
      
      return Game.create!(:name => "Group #{standing.group_stage_name}", 
                          :cup_id => self.id, :home_id => game[0].id ,:away_id => game[1].id, 
                          :starts_at => last_game['starts_at'], :ends_at => last_game['ends_at'], 
                          :reminder_at => last_game['reminder_at'], :deadline_at => last_game['deadline_at'], 
                          :type_name => 'GroupStage', :jornada => last_game['jornada'],
                          :points_for_single => POINTS_FOR_SINGLE, :points_for_double => POINTS_FOR_DOUBLE, 
                          :points_for_winner => POINTS_FOR_WINNER, :points_for_draw => POINTS_FOR_DRAW, 
                          :points_for_goal_difference => POINTS_FOR_GOAL_DIFFERENCE,
                          :points_for_goal_total => POINTS_FOR_GOAL_TOTAL)
    end
  end
  
  # destroy duplicate games for cup round in group stage 
  def destroy_group_stage_game(game)    
    # puts "destroy:  #{self.first_round.jornada}: #{game[0].name} vs #{game[1].name} "
    
    @game = Game.find(:first, :conditions => ["cup_id = ? and home_id = ? and away_id = ? and type_name = 'GroupStage'", 
                    self.id, game[0].id, game[1].id])
    unless @game.nil?
      # puts "destroy:  #{self.first_round.jornada}: #{game[0].name} vs #{game[1].name} "
      @game.destroy
    end
  end
  
  def create_final_stage(escuadras)
    first_round_games = generate_cup_bracket(escuadras)
  end

  # generate a single elimination cup for N teams, numbered 1..N
  def generate_cup_bracket(teams)
    @participants = teams
    @participant_number = @participants.length
    @levels = @participant_number.log2
    @levels = (1<<(@levels) == @participant_number) ? @levels -1 : @levels
    @total_matchups = 1<<(@levels)
    (@participant_number..(2*@total_matchups - 1)).each do |x| 
      @participants << nil 
    end
    
    # puts @levels

    left_index, right_index = 1, 2

    @tree = [[left_index, right_index]] 
    @the_nodes = []      
    @match = 0

    (0..@levels).each do |level|
      game = (1<<level) - 1 
      nodes = @tree[-(game+1)/2,(game+1)/2].inject([]) {|s,e| s+e}        
      @the_nodes << nodes
      i = 0
      nodes.each do |index|      
        opponent = ((2*(game+1)-index+1) > @participant_number) ? nil : (2*(game+1) - index+1)
        if i < game
          @tree << [index, opponent]
          # puts "[z]:  #{index} vs #{opponent}"
        else  
          @tree << [opponent, index]
          # puts "[M]:  #{index} vs #{opponent}"
        end 
        i += 1
      end       
    end
      
      @tree << [left_index, right_index]
      # puts "[Final]:  #{left_index} vs #{right_index}"
      
      # @jornada = 0
      level = @levels
      counter = @levels + 1
      while counter > 0
        game = (1<<(level)) - 1    
        i = 0
        @the_nodes[counter-1].each do |index|     
          next_game= ""

          player_1 = @participants[index-1].name          
          home_id = @participants[index-1].id

          opponent =  'Bye'    
          player_2 = 'Bye'           
          away_id = nil

          unless (2*(game+1)-index+1) > @participant_number
            opponent =  (2*(game+1) - index+1)   
            player_2 = @participants[opponent-1].name 
            away_id = @participants[opponent-1].id
          end


          last_game = get_the_last_game
          
          if level == @levels      
            @game = Game.create!(:name => level_in_words(level), 
                                :cup_id => self.id, :home_id => home_id ,:away_id => away_id,  
                                :starts_at => last_game['starts_at'], :ends_at => last_game['ends_at'], 
                                :reminder_at => last_game['reminder_at'], :deadline_at => last_game['deadline_at'], 
                                :type_name => 'FirstGame', :jornada => last_game['jornada'],  
			                          :points_for_single => POINTS_FOR_SINGLE, :points_for_double => POINTS_FOR_DOUBLE, 
			                          :points_for_winner => POINTS_FOR_WINNER, :points_for_draw => POINTS_FOR_DRAW, 
			                          :points_for_goal_difference => POINTS_FOR_GOAL_DIFFERENCE,
			                          :points_for_goal_total => POINTS_FOR_GOAL_TOTAL)
                                                              
                                puts "[#{level_in_words(level)}]:  #{home_id} #{ away_id}"
          
          else
            @previous_1 = Game.find(:first, 
            :conditions => ["cup_id = ? and home_id = ? and type_name != 'GroupStage' and next_game_id is null", self.id, home_id], 
            :order => "id")            
            @previous_2 = Game.find(:first, 
            :conditions => ["cup_id = ? and home_id = ? and type_name != 'GroupStage' and next_game_id is null", self.id, away_id], 
            :order => "id")

            puts "[#{level_in_words(level)}]:  #{@previous_1.id} #{ @previous_2.id}"

            @game = Game.create!(:name => level_in_words(level), 
                                :cup_id => self.id, :home_id => home_id ,:away_id => away_id,  
                                :starts_at => last_game['starts_at'], :ends_at => last_game['ends_at'], 
                                :reminder_at => last_game['reminder_at'], :deadline_at => last_game['deadline_at'], 
                                :type_name => 'SubsequentGame', :jornada => last_game['jornada'],  
			                          :points_for_single => POINTS_FOR_SINGLE, :points_for_double => POINTS_FOR_DOUBLE, 
			                          :points_for_winner => POINTS_FOR_WINNER, :points_for_draw => POINTS_FOR_DRAW, 
			                          :points_for_goal_difference => POINTS_FOR_GOAL_DIFFERENCE,
			                          :points_for_goal_total => POINTS_FOR_GOAL_TOTAL)
                                
            @previous_1.next_game_id = @game.id
            @previous_1.save!
            @previous_2.next_game_id = @game.id
            @previous_2.save!
          end           
        end

        level -= 1
        counter -=1
      end

      last_game = get_the_last_game
       
      # third place
      jornada = Game.last_cup_game(self).jornada.to_i + 1    
      @game = Game.create!(:name => level_in_words(99), :cup_id => self.id,  
                          :starts_at => last_game['starts_at'], :ends_at => last_game['ends_at'], 
                          :reminder_at => last_game['reminder_at'], :deadline_at => last_game['deadline_at'], 
                          :type_name => 'ThirdPlaceGame', :jornada => last_game['jornada'],  
                          :points_for_single => POINTS_FOR_SINGLE, :points_for_double => POINTS_FOR_DOUBLE, 
                          :points_for_winner => POINTS_FOR_WINNER, :points_for_draw => POINTS_FOR_DRAW, 
                          :points_for_goal_difference => POINTS_FOR_GOAL_DIFFERENCE,
                          :points_for_goal_total => POINTS_FOR_GOAL_TOTAL)
                                              
      # final
      home_id = @participants[left_index-1].id
      away_id = @participants[right_index-1].id
      player_1 = @participants[left_index-1].name
      player_2 = @participants[right_index-1].name     
      
      jornada = Game.last_cup_game(self).jornada.to_i + 1
      @previous_1 = Game.find(:first, 
      :conditions => ["cup_id = ? and home_id = ? and type_name != 'GroupStage' and next_game_id is null", self.id, home_id], 
      :order => "id")            
      @previous_2 = Game.find(:first, 
      :conditions => ["cup_id = ? and home_id = ? and type_name != 'GroupStage' and next_game_id is null", self.id, away_id], 
      :order => "id")
      
      puts "[#{level_in_words(0)}]:  #{@previous_1.id} #{ @previous_2.id}"
      
      last_game = get_the_last_game
      @game = Game.create!(:name => level_in_words(0), :cup_id => self.id,  
                          :starts_at => last_game['starts_at'], :ends_at => last_game['ends_at'], 
                          :reminder_at => last_game['reminder_at'], :deadline_at => last_game['deadline_at'], 
                          :type_name => 'FinalGame', :jornada => last_game['jornada'],  
                          :points_for_single => POINTS_FOR_SINGLE, :points_for_double => POINTS_FOR_DOUBLE, 
                          :points_for_winner => POINTS_FOR_WINNER, :points_for_draw => POINTS_FOR_DRAW, 
                          :points_for_goal_difference => POINTS_FOR_GOAL_DIFFERENCE,
                          :points_for_goal_total => POINTS_FOR_GOAL_TOTAL)
                                
      @previous_1.next_game_id = @game.id
      @previous_1.save!
      @previous_2.next_game_id = @game.id
      @previous_2.save!
    end
    
    def get_the_last_game      
      last_game = Game.last_cup_game(self)

       # default values
       the_game = {"starts_at" =>  self.starts_at, "ends_at" =>  self.starts_at + (60 * 60 * 2), 
                   "reminder_at" => self.starts_at - 1.day, "deadline_at" => self.starts_at - 2.days, "jornada" => 1}

       unless last_game.nil?
         the_game['starts_at'] =  last_game.starts_at + 1.day
         the_game['ends_at'] =  last_game.starts_at + 1.day + (60 * 60 * 2)
         the_game['reminder_at'] = last_game.starts_at - 1.day
         the_game['jornada'] = last_game.jornada.to_i + 1
       end
       
       return the_game
     end

    def remove_subesequent_games
      #remove subsequent home and away players from games
      @games = Game.find(:all, :conditions => ["cup_id = ? and type_name != 'GroupStage'", self.id])    
      @games.each do |game| 
        game.home_id = nil
        game.away_id = nil
        game.save!
      end
        
      @games = Game.find(:all, :conditions => ["cup_id = ?", self.id])  
      @games.each do |game| 
        game.winner_id = nil
        game.home_score = nil
        game.away_score = nil
        game.save!
      end
    end
    
    def level_in_words(level)
      case level
      when -1
        'Champion'
      when 0
        'Finals'
      when 1
        'Semifinals'
      when 2
        'Quarterfinals'
      when 3
        "Round of 16"
      when 99
        "Third Place"
      else
        "Round #{level.ordinalize}"
      end
    end

private

  def validate
    self.errors.add(:deadline_at, I18n.t(:must_be_before_starts_at)) if self.deadline_at >= self.starts_at
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
  end
end



class Fixnum
  def log2
    i = 0
    value = self
    while(value > 1) 
      value >>= 1
      i += 1
    end 
    i
  end
end
