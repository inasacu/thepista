# TABLE "subplugs"
# t.string   "name"
# t.integer  "enchufado_id"
# t.integer  "play_id"
# t.integer  "service_id"
# t.string   "url"
# t.string   "slug"
# t.boolean  "archive"
# t.datetime "created_at"
# t.datetime "updated_at"


class Subplug < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name_slug, 			use: :slugged

	# validations  
	validates_presence_of         :name
	validates_length_of           :name,                            :within => NAME_RANGE_LENGTH
	validates 										:url, 												 :format => URI::regexp(%w(http https))

	# variables to access
	attr_accessible :name, :enchufado_id, :enchufado_id, :play_id, :service_id, :url, :slug, :archive

	belongs_to	:enchufados
	has_many 		:groups, 					:as => :item


	
	# method section
	def name_slug
		# "#{self.enchufado.name} #{name}"
		"#{name}"
	end

	def self.subplug_name(enchufado)
		find(:all, :select => "distinct subplugs.id, subplugs.name", 
		:conditions => ["enchufado_id = ?", enchufado], :order => "name").collect {|p| [p.name, p.id ] }
	end

	def self.current_subplugs(enchufado, page = 1)
		self.where("enchufado_id = ?", enchufado).page(page).order('name')
	end

	def self.get_previous_subplug(enchufado)	
		find.where("enchufado_id = ? and archive = false", @enchufado.id).order("created_at DESC").first()
	end

end

