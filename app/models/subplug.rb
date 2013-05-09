# == Schema Information
#
# Table name: subplugs
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  enchufado_id :integer
#  venue_id     :integer          default(999)
#  play_id      :integer          default(61)
#  service_id   :integer          default(51)
#  url          :string(255)
#  slug         :string(255)
#  archive      :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


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

