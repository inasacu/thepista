# == Schema Information
#
# Table name: branches
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  company_id         :integer
#  city_id            :integer          default(1)
#  venue_id           :integer
#  service_id         :integer          default(51)
#  play_id            :integer          default(61)
#  starts_at          :datetime
#  ends_at            :datetime
#  timeframe          :float            default(1.0)
#  url                :string(255)
#  public             :boolean          default(TRUE)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  description        :text
#  api                :string(255)
#  secret             :string(255)
#  slug               :string(255)
#  archive            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Branch < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name_slug, 			use: :slugged

	# validations  
	validates_presence_of         :name, :company_id
	validates_length_of           :name,                  :within => NAME_RANGE_LENGTH
	validates 										:url, 									:format => URI::regexp(%w(http https))
	validates_uniqueness_of       :url,            				:case_sensitive => false
	
	# variables to access
	attr_accessible :name, :company_id, :city_id, :venue_id, :service_id, :play_id, :starts_at, :ends_at, :timeframe, :url, :public, :photo, :description, :slug, :archive

	belongs_to	:company	
	belongs_to	:city
	has_many 		:groups, 					:as => :item


	# method section
	def name_slug
		"#{name}"
	end

	def self.subplug_name(company)
		find(:all, :select => "distinct subplugs.id, subplugs.name", 
		:conditions => ["company_id = ?", company], :order => "name").collect {|p| [p.name, p.id ] }
	end

	def self.current_subplugs(company, page = 1)
		self.where("company_id = ?", company).page(page).order('name')
	end

	def self.get_previous_subplug(company)	
		find.where("company_id = ? and archive = false", @company.id).order("created_at DESC").first()
	end

	def create_branch_details(user)
		user.has_role!(:manager, self)
		user.has_role!(:creator, self)
	end
	
	
	# WIDGET PROJECT
	
	def self.branch_from_url(url)
	  self.where("url like ?", "%#{url}%").first
	end

end


