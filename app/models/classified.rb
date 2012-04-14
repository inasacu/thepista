class Classified < ActiveRecord::Base

	# extend FriendlyId 
	# friendly_id :name, 			use: :slugged

	belongs_to      :table,           :polymorphic => true
	belongs_to      :item,            :polymorphic => true

	# validations  
	validates_presence_of         :name
	validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
	validates_format_of           :name,                         :with => /^[A-z 0-9 _.-]*$/ 

	validates_presence_of         :description
	validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

	validates_presence_of         :starts_at,     :ends_at

	# variables to access
	attr_accessible :name, :description, :starts_at, :table_id, :table_type, :slug 
	

	before_create       :format_description

	# method section
	def self.latest_items(items)
		find.where("created_at >= ? and archive = false", LAST_WEEK).select("id, concept, created_at, item_type, item_id").each do |item| 
			items << item
		end
		return items 
	end

	def self.find_classifieds(item, page = 1)
		self.where("table_type = ? and table_id = ?", item.class.to_s, item).page(page).order('starts_at DESC')
	end

	def self.find_all_classifieds(page = 1)
		self.where("created_at >= ? and archive = false", LAST_WEEK).page(page).order('starts_at DESC')
	end

	def self.item_classifieds(item)
		find.where("table_id = ? and table_type = ?", item, item.class.to_s)
	end   

	def self.upcoming_classifieds(hide_time)
		with_scope(:find => where(:starts_at => ONE_WEEK_FROM_TODAY, :archive => false).order("starts_at")) do
			if hide_time.nil?
				self.all()
			else
				self.where("starts_at >= ?", hide_time)
			end
		end
	end

	def self.find_classified_item(item)
		find.where("id = (select max(id) from classifieds where table_id = ? and table_type = ?) ", item, item.class.to_s).first()
	end

	private

	def format_description
		self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
	end

	def set_time_to_utc
		# self.starts_at = self.starts_at.utc
		# self.ends_at = self.ends_at.utc
	end

	def validate
		# self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
		# self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
	end

end

