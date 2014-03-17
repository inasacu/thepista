# == Schema Information
#
# Table name: groups
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  second_team        :string(255)
#  gameday_at         :datetime
#  points_for_win     :float            default(1.0)
#  points_for_draw    :float            default(0.0)
#  points_for_lose    :float            default(0.0)
#  time_zone          :string(255)      default("UTC")
#  sport_id           :integer
#  marker_id          :integer
#  description        :text
#  conditions         :text
#  player_limit       :integer          default(150)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  archive            :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  automatic_petition :boolean          default(TRUE)
#  installation_id    :integer          default(999)
#  slug               :string(255)
#  service_id         :integer          default(51)
#  item_id            :integer
#  item_type          :string(255)
#

class Group < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged

  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/s3.yml",
  :url => "/assets/groups/:id/:style.:extension",
  :path => ":assets/groups/:id/:style.:extension",
  :default_url => IMAGE_GROUP_AVATAR  


  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
  validates_attachment_size         :photo, :less_than => 5.megabytes


  # validations 
  validates_uniqueness_of   :name,    :case_sensitive => false

  validates_presence_of     :name
  validates_presence_of     :second_team
  validates_presence_of     :conditions
  validates_presence_of     :time_zone
  validates_presence_of     :sport_id
  validates_presence_of     :marker_id

  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :second_team,     :within => NAME_RANGE_LENGTH
  validates_length_of       :conditions,      :within => DESCRIPTION_RANGE_LENGTH

  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 
  validates_format_of       :second_team,     :with => /^[A-z 0-9 _.-]*$/ 

  validates_numericality_of :points_for_win,  :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :points_for_lose, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :points_for_draw, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 20
  validates_numericality_of :player_limit,    :greater_than_or_equal_to => 1, :less_than_or_equal_to => DUNBAR_NUMBER

  # variables to access
  attr_accessible :name, :second_team, :gameday_at, :sport_id
	attr_accessible :points_for_win, :points_for_draw, :points_for_lose, :player_limit, :automatic_petition
  attr_accessible :time_zone, :marker_id, :description, :conditions, :photo, :enable_comments, :installation_id, :slug
	attr_accessible	:item_id, :item_type

  has_and_belongs_to_many :users,           :join_table => "groups_users", :conditions => "users.archive = false", :order => "name"

  has_many      :schedules,         :conditions => "schedules.archive = false"
  has_many      :fees,              :conditions => "fees.archive = false"   
  has_many      :payments,          :conditions => "payments.archive = false"
  has_many      :scorecards,        :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"
 
  belongs_to    :sport   
  belongs_to    :marker 
  belongs_to    :installation, 			:include => [ :venue ]
	belongs_to    :item,          		:polymorphic => true

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name in ('manager', 'creator') and roles.authorizable_type = 'Group'"]

  has_many :the_subscriptions,
  :through => :subscription_roles,
  :source => :roles_users

  has_many  :subscription_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'subscription' and roles.authorizable_type = 'Group'"]

  before_create :format_description, :format_conditions
  before_update :format_description, :format_conditions
	after_create	:create_group_marker, :create_group_scorecard

  # related to gem acl9
  acts_as_authorization_subject :association_name => :roles, :join_table_name => :groups_roles

  # method section
	def self.get_site_groups(the_params)
		self.where("groups.archive = false").page(the_params).order('groups.created_at DESC').includes(:item, :schedules, :marker, :sport, :the_managers, :users)
	end
	
	def self.get_branch_groups(the_params)
		self.where("groups.archive = false and 
			groups.item_type is null").page(the_params).order('groups.created_at DESC').includes(:item, :schedules, :marker, :sport, :the_managers, :users)
	end
	
  def all_the_managers
    ids = []
    self.the_managers.each {|user| ids << user.user_id }
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def all_subscribers
    ids = []
    self.users.each {|user| ids << user.user_id if user.is_subscriber_of?(self)}
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def all_non_subscribers
    ids = []
    self.users.each {|user| ids << user.user_id unless user.is_subscriber_of?(self)}
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def total_managers
    counter = 0
    self.all_the_managers.each {|user| counter += 1}
    return counter
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

  def name_to_second_team
    unless self.name.blank?
      self.second_team = "#{self.name} II"
      self.second_team.split(".").map {|n| n.capitalize }.join(" ")
    end
  end

  def name_to_description
    self.description = I18n.t(:description)
  end

  def default_conditions
    self.conditions = I18n.t(:default_group_conditions)
  end

  def sport_to_points_player_limit
    if self.sport
      self.points_for_win = self.sport.points_for_win
      self.points_for_draw = self.sport.points_for_draw
      self.points_for_lose = self.sport.points_for_lose
      self.player_limit = self.sport.player_limit   
 			self.marker_id = 2
    end
  end

  def has_schedule?
    self.schedules.count > 0
  end

  def is_futbol?
    # sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end

  def is_basket?
    # sports related to basket
    return [7].include?(self.sport_id)
  end

	def is_branch?
		return (self.item_type == 'Branch')
	end

	def get_branch
		self.item if self.is_branch?
	end
	
	def get_company
		self.item.company if self.is_branch?
	end

  def is_group_member_of?(item)
    self.has_role?('member', item)
  end	

	def is_subscriber_of?(item)
		self.has_role?('subscription', item) 
	end
  
  def venue
    self.installation.venue
  end

	def payed_service
		type_payed_service = [52, 53, 54]
		return type_payed_service.include?(self.service_id)
	end

  def self.latest_items(items)
    find(:all, :conditions => ["created_at >= ? and archive = false and item_type is null", LAST_WEEK]).each do |item|
      items << item
    end
    return items 
  end

  def self.latest_updates(items)
    find(:all, :select => "id, name, photo_file_name, updated_at as created_at", :conditions => ["updated_at >= ? and archive = false and item_type is null", LAST_THREE_DAYS]).each do |item| 
      items << item
    end
    return items 
  end

  def games_played
    games_played = 0
    self.schedules.each {|schedule| games_played += 1 if schedule.played}
    return games_played
  end

	def create_group_roles(user)
		user.has_role!(:manager, self)
		user.has_role!(:creator, self)
		user.has_role!(:member,  self)

		Scorecard.create_user_scorecard(user, self)    
		GroupsUsers.join_team(user, self)

		# add all default users to team
		all_default_users = User.where('id in (?)', DEFAULT_GROUP_USERS)
		all_default_users.each do |user|
			user.has_role!(:member,  self)
			Scorecard.create_user_scorecard(user, self)    
			GroupsUsers.join_team(user, self)
		end

	end

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end

  private
  def create_group_marker
    GroupsMarkers.join_marker(self, self.marker)
  end

  def create_group_scorecard   
    Scorecard.create_group_scorecard(self)
  end
  
  public
  # WIDGET ----------------------------
  
  def self.add_user_togroup(user, group)
    
    if !user.is_member_of?(group)
      
      # 
      role_user = RolesUsers.find_item_manager(group)
      manager = User.find(role_user.user_id)
      Teammate.create_teammate_pre_join_item(user, manager, group, nil)
      
      # 
      Teammate.create_teammate_join_item(manager, user, group, nil)
    
    else
      
    end
    
  end
  
  # MOBILE --------------------------
  def active_schedules
    self.schedules.where("starts_at >= ?", Time.zone.now)
  end
  
  def self.starred
    begin
      starred = self.groups_info(self.limit(5))
    rescue Exception => exc
      logger.error("Exception while getting starred groups #{exc.message}")
      logger.error("#{exc.backtrace}")
      starred = nil
    end
    return starred
  end
  
  def self.user_groups(user_id)
    begin
      user = User.find(user_id)
      groups = self.groups_info(user.groups)
    rescue Exception => exc
      logger.error("Exception while getting user groups #{exc.message}")
      logger.error("#{exc.backtrace}")
      groups = nil
    end
    return groups
  end
  
  def self.groups_info(groups)
    groups_array = Array.new
	  groups.each do |group|
      group_m = Mobile::GroupM.new(group)
      groups_array << group_m
    end
    return groups_array
  end 

  # MOBILE
  def self.create_new(group_map=nil)
    if group_map
      new_group = Group.new
      begin
        new_group_mobile = nil
        Group.transaction do
          # gets the user who is creating the group
          user_id = group_map["group_creator"]
          creator = User.find(user_id)

          # sets group properties
          new_group.name = group_map["group_name"]
          new_group.sport_id = group_map["group_sport"]
          new_group.name_to_second_team
          new_group.default_conditions
          new_group.sport_to_points_player_limit
          new_group.time_zone = creator.time_zone if !creator.time_zone.nil?

          # creates the group
          new_group.save!

          # creates roles for creator
          new_group.create_group_roles(creator)

          new_group_mobile = Mobile::GroupM.new(new_group)

        end # end transaction
      rescue Exception => e
        logger.error("Exception while creating group #{e.message}")
        logger.error("#{e.backtrace}")
        new_group_mobile = nil
      end

      return new_group_mobile
    else
      logger.debug "Null map for the group info"
      return nil
    end
  end

  def self.add_member(group_id=nil, user_id=nil)
    if group_id and user_id
      add_response = nil
      begin
        Group.transaction do
          # get user
          new_member = User.find(user_id)

          # get group
          the_group = Group.find(group_id)

          # add member role to user
          new_member.has_role!(:member,  the_group)

          # relate group with user 
          GroupsUsers.join_team(new_member, the_group)

          # update scorecards
          Scorecard.create_user_scorecard(new_member, the_group)

          # prepare response
          the_group = Group.find(group_id)
          add_response = Mobile::GroupM.new(the_group)

        end # end transaction
      rescue Exception => e
        logger.error("Exception while adding member to group #{e.message}")
        logger.error("#{e.backtrace}")
        add_response = nil
      end

      return add_response
    else
      logger.debug "Null group id and user id"
      return nil
    end
  end

  def self.get_info_related_to_user(group_id=nil, user_id=nil)
    if group_id and user_id
      group_info = nil
      begin
        Group.transaction do
          the_group = Group.find(group_id)
          the_user = User.find(user_id)

          user_data = Hash.new
          user_data[:user_id] = user_id
          user_data[:is_member] = the_user.has_role?(:member,  the_group)
          user_data[:is_creator] = the_user.has_role?(:creator,  the_group)
          user_data[:is_manager] = the_user.has_role?(:manager,  the_group)

          group_info = Hash.new
          group_info[:group] = Mobile::GroupM.new(the_group)
          group_info[:user_data] = user_data
          

        end # end transaction
      rescue Exception => e
        logger.error("Exception while getting group info #{e.message}")
        logger.error("#{e.backtrace}")
        group_info = nil
      end

      return group_info
    else
      logger.debug "Null group id and user id"
      return nil
    end
  end
  
end

