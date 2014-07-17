# == Schema Information
#
# Table name: challenges
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  cup_id             :integer
#  starts_at          :datetime
#  ends_at            :datetime
#  reminder_at        :datetime
#  fee_per_game       :float            default(0.0)
#  time_zone          :string(255)
#  description        :text
#  conditions         :text
#  player_limit       :integer          default(99)
#  archive            :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  automatic_petition :boolean          default(TRUE)
#  slug               :string(255)
#  service_id         :integer          default(51)
#

class Challenge < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged
  
  # validations 
  validates_uniqueness_of       :name,            :case_sensitive => false

  validates_presence_of         :name
  validates_presence_of         :description
  validates_presence_of         :conditions
  validates_presence_of         :time_zone

  validates_length_of           :name,            :within => NAME_RANGE_LENGTH
  validates_length_of           :description,     :within => DESCRIPTION_RANGE_LENGTH
  validates_length_of           :conditions,      :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :fee_per_game
  validates_numericality_of     :fee_per_game

  validates_format_of           :name,            :with => /^[A-z 0-9 _.-]*$/ 

  validates_numericality_of     :player_limit,    :greater_than_or_equal_to => 1, :less_than_or_equal_to => DUNBAR_NUMBER

  # variables to access
  attr_accessible :name, :cup_id, :starts_at, :ends_at, :reminder_at, :fee_per_game, :time_zone, :description, :conditions, :player_limit, :archive, :automatic_petition, :slug
                   
  has_and_belongs_to_many :users,   :conditions => 'users.archive = false',   :order => 'name'

  belongs_to    :cup
  has_many      :casts
  has_many      :messages 
  has_many      :payments
  has_many      :fees
  has_many      :standings, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "points DESC, ranking"

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :active_users,
  :class_name => "Cast", 
  :foreign_key => "challenge_id", 
	:select => "distinct casts.user_id",
  :conditions => ["casts.archive = false and casts.home_score is not null and casts.away_score is not null"]

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Challenge'"]

  before_create :format_description, :format_conditions
  before_update :format_description, :format_conditions

  def all_the_managers
    ids = []
    self.the_managers.each {|user| ids << user.user_id }
    the_users = User.find(:all, :conditions => ["id in (?)", ids], :order => "name")
  end

  def total_managers
    counter = 0
    self.all_the_managers.each {|user| counter += 1}
    return counter
  end

  def avatar
    self.cup.photo.url
  end

  def thumbnail
    self.cup.photo.url
  end

  def icon
    self.cup.photo.url
  end
  
  def has_cast?
    self.casts.count > 0
  end

  def is_futbol?
    # sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end

  def is_basket?
    # sports related to basket
    return [7].include?(self.sport_id)
  end
  
  def points_for_double
    self.cup.games.first.points_for_double
  end

  def create_challenge_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)

    ChallengesUsers.join_item(user, self)
    Standing.delay.create_cup_challenge_standing(self) if USE_DELAYED_JOBS
    Standing.create_cup_challenge_standing(self).deliver unless USE_DELAYED_JOBS
    Cast.delay.create_challenge_cast(self) if USE_DELAYED_JOBS
    Cast.create_challenge_cast(self).deliver unless USE_DELAYED_JOBS
    
    if DISPLAY_PROFESSIONAL_SERVICES
      Fee.delay.create_user_challenge_fees(self) if USE_DELAYED_JOBS
      Fee.create_user_challenge_fees(self).deliver unless USE_DELAYED_JOBS
    end
    
  end 

	def self.get_challenge_list
		find.where("archive = false and id not in (?)", current_user.challenges).page(params[:page]).order('challenges.name') 
  end

  def self.current_challenges(page = 1)
    self.where("ends_at > ? and archive = false", Time.zone.now).page(page).order('starts_at')
  # end
    # self.where("cup_id in (select id from cups where archive = false)").page(page).order('name')
  end 
  
  def self.latest_items(items)
    find(:all, :conditions => ["created_at >= ?", LAST_WEEK], :order => "id desc").each do |item| 
      items << item
    end
    return items
  end

	def challenge_payed_service
		type_payed_service = [52, 53, 54]
		return type_payed_service.include?(self.service_id)
	end

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def format_conditions
    self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
  end

  private
  def validate
    self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
  end

end

