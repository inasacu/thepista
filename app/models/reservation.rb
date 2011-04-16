class Reservation < ActiveRecord::Base

  index{ concept }

  has_many    :fees,            :dependent => :destroy 
  belongs_to  :item,            :polymorphic => true
  belongs_to  :installation
  belongs_to  :venue
  
  # validations  
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/ 

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :fee_per_game,  :fee_per_lighting
  validates_numericality_of     :fee_per_game,  :fee_per_lighting

  validates_presence_of         :starts_at, :ends_at

  # variables to access
  attr_accessible :concept, :description, :starts_at, :ends_at, :reminder_at, :reminder
  attr_accessible :fee_per_game, :fee_per_lighting, :venue_id, :installation_id, :public, :archive

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :concept, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  # after_update        :save_matches
  before_create       :format_description
  before_update       :format_description
  
  # method section
  def self.current_reservations(installation, page = 1)
    self.paginate(:all, :conditions => ["installation_id = ? and starts_at >= ? and ends_at <= ?", installation, installation.starts_at, installation.ends_at], 
                        :order => 'concept', :page => page, :per_page => INSTALLATIONS_PER_PAGE)
  end
  
  def self.weekly_reservations(installation, starts_at, ends_at)
    self.find(:all, :conditions => ["installation_id = ? and starts_at >= ? and ends_at < ?", installation, starts_at, ends_at], :order => 'starts_at')
  end
  
  def self.list_reservations(venue, page = 1)
    self.paginate(:all, :conditions => ["venue_id = ?", venue], :order => 'concept', :page => page, :per_page => INSTALLATIONS_PER_PAGE)
  end


  private

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def validate
    if self.archive == false
      self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at 
      self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at 
    end
  end

end
