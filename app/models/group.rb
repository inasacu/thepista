class Group < ActiveRecord::Base

  acts_as_solr :fields => [:name, :second_team, :description, :time_zone], :include => [:sport, :marker] if use_solr?


  # validations 
  validates_uniqueness_of   :name,          :message => "has already been taken" 
  validates_presence_of     :name,          :within => NAME_RANGE_LENGTH
  # validates_format_of       :name,          :with => /^.+ .+$/
  # validates_format_of       :name,          :with => /^[A-Z0-9_]$/i, :message =>"must contain only letters, numbers and underscores"

  validates_presence_of     :second_team,   :within => NAME_RANGE_LENGTH
  validates_presence_of     :description,   :within => DESCRIPTION_RANGE_LENGTH
  validates_presence_of     :time_zone
  validates_presence_of     :sport_id
  validates_presence_of     :marker_id


  # attr_accessible :photo, :points_for_win, :points_for_draw, :points_for_lose
  
  has_and_belongs_to_many :users,           :join_table => "groups_users",   :order => "name"
    
  has_many      :schedules
  has_many      :addresses  
  has_many      :accounts 
  has_many      :messages
  has_many      :accounts  
  has_many      :payments
  has_many      :scorecards, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"
  has_many      :fees   

  has_many :the_managers,
           :through => :manager_roles,
           :source => :roles_users
  
  has_many  :manager_roles,
            :class_name => "Role", 
            :foreign_key => "authorizable_id", 
            :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Group'"]
  
  belongs_to    :sport   
  belongs_to    :marker 
  
  has_one       :blog
  
  after_create :create_group_blog_details, 
  
  # method section
  
  # def all_the_managers
  #   ids = []
  #   self.the_managers.each {|user| ids << user.user_id }
  #   the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  # end
  # 
  # def self.per_page
  #   5
  # end
  # 
  #   def the_avatar
  #     # self.photo.url
  #     return "default_avatar.jpg"
  #   end
  # 
  # def is_same_group(group)
  #   (self == group)
  # end
  # 
  # def game_day
  #   self.schedules.find_by_sql(["select distinct dayname(starts_at) as name from schedules " +
  #                                "where group_id = #{self.id} or invite_id = #{self.id} " +
  #                                "group by dayname(starts_at) order by dayofweek(starts_at)"])
  # end
  # 
  # def available_users
  #   return group_available_users(0)
  # end
  # 
  # def group_available_users(user)
  #     self.users.find(:all, :conditions => ['default_available = true', user.id], :order => 'users.name')      
  # end
  # 
  # # def self.all_ordered
  # #   find :all, :order => "name"
  # # end
  # 
  # def schedule_played
  #   self.schedules.find( :all, :conditions => [ 'group_id = ? and played = true', self.id ], :order => 'starts_at desc')
  # end
  # 
  # def schedule_not_played
  #   self.schedules.find( :all, :conditions => [ 'group_id = ? and played = false', self.id ])
  # end

private


  def create_group_blog_details
    @blog = Blog.create_group_blog(self)
    @entry = Entry.create_group_entry(self, @blog)
    Comment.create_group_comment(self, @blog, @entry)
  end
  
  def create_group_details
      # Scorecard.create(:group_id => self.id) if Scorecard.find_by_group_id(self.id).nil?     
      Scorecard.create_group_scorecard(self)
  end
end
