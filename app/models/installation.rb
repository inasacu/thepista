# == Schema Information
#
# Table name: installations
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  venue_id           :integer
#  sport_id           :integer
#  marker_id          :integer
#  starts_at          :datetime
#  ends_at            :datetime
#  timeframe          :float            default(1.0)
#  fee_per_pista      :float            default(0.0)
#  fee_per_lighting   :float            default(0.0)
#  public             :boolean          default(TRUE)
#  lighting           :boolean          default(TRUE)
#  outdoor            :boolean          default(TRUE)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  description        :text
#  conditions         :text
#  archive            :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  slug               :string(255)
#

class Installation < ActiveRecord::Base

	extend FriendlyId 
	# friendly_id :name, 						use: 				:slugged
	friendly_id :name_slug,				use:  			:slugged

	def name_slug
		"#{self.venue.name} #{name}"
	end


	has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
	:storage => :s3,
	:s3_credentials => "#{Rails.root}/config/s3.yml",
	:url => "/assets/installations/:id/:style.:extension",
	:path => ":assets/installations/:id/:style.:extension",
	:default_url => IMAGE_GROUP_AVATAR  

	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
	validates_attachment_size         :photo, :less_than => 5.megabytes

	belongs_to      :venue
	belongs_to      :marker
	belongs_to      :sport  
	has_many        :reservations
	has_many        :groups,            :conditions => "groups.archive = false"
	has_many        :timetables,        :order => "timetables.type_id, timetables.starts_at"

	# validations  
	validates_presence_of         :name
	validates_length_of           :name,                            :within => NAME_RANGE_LENGTH

	validates_presence_of         :description
	validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

	validates_presence_of         :fee_per_pista,  :fee_per_lighting, :timeframe
	validates_numericality_of     :fee_per_pista,  :fee_per_lighting, :timeframe
	validates_presence_of         :starts_at,     :ends_at 

	# variables to access
	attr_accessible :name, :description, :conditions, :starts_at, :ends_at, :timeframe
	attr_accessible :fee_per_pista, :fee_per_lighting, :venue_id, :sport_id, :marker_id
	attr_accessible :public, :lighting, :outdoor, :archive, :photo, :slug

	# after_update        :save_matches
	before_create       :format_description, :format_conditions
	before_update       :format_description, :format_conditions

	# method section
	def venue_and_name
		"#{venue.name} #{name}"
	end

	def self.installation_name(venue)
		find(:all, :select => "distinct installations.id, installations.name", 
		:conditions => ["venue_id = ?", venue], :order => "name").collect {|p| [p.name, p.id ] }
	end

	def self.current_installations(venue, page = 1)
		self.where("venue_id = ?", venue).page(page).order('name')
	end

	def self.get_previous_installation(venue)	
		find.where("venue_id = ? and archive = false", @venue.id).order("created_at DESC").first()
	end

	private

	def format_description
		self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
	end

	def format_conditions
		self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
	end

	def validate
		if self.archive == false
			# self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at 
			self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
			self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at 
		end
	end

end

