# TABLE "enchufados"
# t.string   "name"
# t.string   "url"
# t.string   "language"
# t.boolean  "public"
# t.integer  "venue_id"
# t.integer  "category_id"
# t.integer  "play_id"
# t.integer  "service_id"
# t.string   "api"
# t.string   "secret"
# t.string   "photo_file_name"
# t.string   "photo_content_type"
# t.integer  "photo_file_size"
# t.datetime "photo_updated_at"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.string   "slug"
# t.boolean  "archive"


class Enchufado < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name_slug, 			use: :slugged

	has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
	:storage => :s3,
	:s3_credentials => "#{Rails.root}/config/s3.yml",
	:url => "/assets/venues/:id/:style.:extension",
	:path => ":assets/venues/:id/:style.:extension",
	:default_url => IMAGE_GROUP_AVATAR  

	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
	validates_attachment_size         :photo, :less_than => 5.megabytes

	# validations  
	validates_presence_of         :name
	validates_length_of           :name,                         :within => NAME_RANGE_LENGTH
	validates 										:url, 												 :format => URI::regexp(%w(http https))

	# variables to access
	attr_accessible :name, :url, :language, :public, :venue_id, :category_id, :play_id, :service_id, :photo, :slug

	has_many :the_managers,
	:through => :manager_roles,
	:source => :roles_users

	has_many  :manager_roles,
	:class_name => "Role", 
	:foreign_key => "authorizable_id", 
	:conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Enchufado'"]

	has_many      :subplugs

	before_create	:generate_api, :generate_secret


	# related to gem acl9
	acts_as_authorization_subject :association_name => :roles, :join_table_name => :roles_enchufados

	def name_slug
		return Base64.urlsafe_encode64("#{name} #{id}")	
	end

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

	def self.enchufado_name
		return find(:all, :conditions => ["archive = false"], :order => "enchufados.name").collect {|p| [ p.name, p.id ] }
	end

	def create_enchufado_details(user)
		user.has_role!(:manager, self)
		user.has_role!(:creator, self)
	end

	private
	def generate_api
		self.api = Base64.urlsafe_encode64("#{name} #{id}")	
	end

	def generate_secret
		self.secret = Base64.urlsafe_encode64("#{name} #{id}")	
	end

end
