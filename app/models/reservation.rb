# == Schema Information
#
# Table name: reservations
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  starts_at        :datetime
#  ends_at          :datetime
#  reminder_at      :datetime
#  venue_id         :integer
#  installation_id  :integer
#  item_id          :integer
#  item_type        :string(255)
#  fee_per_pista    :float            default(0.0)
#  fee_per_lighting :float            default(0.0)
#  available        :boolean          default(TRUE)
#  reminder         :boolean          default(TRUE)
#  public           :boolean          default(TRUE)
#  description      :text
#  block_token      :string(255)
#  archive          :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  code             :string(255)
#  slug             :string(255)
#

class Reservation < ActiveRecord::Base

	# extend FriendlyId 
	# friendly_id :name, 			use: :slugged
	  

  belongs_to  :item,            :polymorphic => true
  belongs_to  :installation
  belongs_to  :venue
  
  # validations  
  validates_presence_of         :name
  validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
  # validates_format_of           :name,                         :with => /^[A-z 0-9 _.-]*$/ 

  # validates_presence_of         :description
  # validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :fee_per_pista,  :fee_per_lighting
  validates_numericality_of     :fee_per_pista,  :fee_per_lighting

  # validates_presence_of         :starts_at, :ends_at

  # variables to access
  attr_accessible :name, :description, :starts_at, :ends_at, :reminder_at
  attr_accessible :fee_per_pista, :fee_per_lighting, :venue_id, :installation_id
  attr_accessible :item_id, :item_type, :block_token, :code
  attr_accessible :public, :archive, :reminder, :available, :slug

  # after_update        :save_matches
  before_create       :format_description
  before_update       :format_description
  
  # method section
  def self.current_reservations(installation, page = 1)
    self.where("installation_id = ? and starts_at >= ? and ends_at <= ?", installation, installation.starts_at, installation.ends_at).page(page).order('concept')
  end
  
  def self.weekly_reservations(installation, starts_at, ends_at)
    self.find(:all, :conditions => ["installation_id = ? and starts_at >= ? and ends_at < ?", installation, starts_at, ends_at], :order => 'starts_at')
  end
  
  def self.list_reservations(venue, page = 1)
    self.where("venue_id = ?", venue).page(page).order('concept')
  end

  def self.latest_items(items)
    the_reservations = []
    find(:all, :conditions => ["reservations.created_at >= ? and archive = false", LAST_WEEK], :order => "created_at DESC").each do |item| 
      has_the_item = false

      # only add unique values
      the_reservations.each do |reservation|             
        has_the_item = (reservation.venue_id == item.venue_id and 
                        reservation.installation_id == item.installation_id and 
                        reservation.item_id == item.item_id and 
                        reservation.item_type == item.item_type) if !has_the_item          
      end           
      items << item unless has_the_item
      the_reservations << item           
    end
    return items
  end
  
  def self.reservation_available(venue, installation, reservation)
      find(:first, :conditions =>["venue_id = ? and installation_id = ? and starts_at = ? and ends_at = ? and 
                                   item_id is not null and item_type is not null", venue, installation, reservation.starts_at, reservation.ends_at]).nil?
  end

	def self.get_reservation_first_to_last_month(first_day, last_day, installation)
		find(:all, :conditions => ["installation_id = ? and reservations.archive = false and reservations.starts_at >= ? and 
																reservations.ends_at <= ?", installation, first_day, last_day], :order => 'starts_at')
	end
	
	def self.get_reservation_item_first_to_last_month(first_day, last_day, item)
		find(:all, :conditions => ["reservations.archive = false and reservations.starts_at >= ? and 
																reservations.ends_at <= ? and reservations.item_id = ? and reservations.item_type = ?", first_day, last_day, item.id, item.class.to_s.downcase.chomp], :order => 'starts_at')
	end
		
  private

  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

  def validate
    if self.archive == false
      # self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at 
      # self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      # self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at 
    end
  end

end
