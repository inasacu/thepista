class Venue < ActiveRecord::Base

  index do
    name
    description
  end
                  
  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/venues/:id/:style.:extension",
    :path => ":assets/venues/:id/:style.:extension",
    :default_url => "group_avatar.png"  
    
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes
    

  # validations 
  validates_uniqueness_of   :name,            :case_sensitive => false  
  validates_presence_of     :name,            :description, :time_zone, :starts_at,     :ends_at
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/ 

  # variables to access
  attr_accessible :name, :description, :starts_at, :ends_at, :time_zone, :marker_id, :description, :photo, :enable_comments, :public
    
  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]
                  

  has_many :the_managers,
  :through => :manager_roles,
  :source => :roles_users

  has_many  :manager_roles,
  :class_name => "Role", 
  :foreign_key => "authorizable_id", 
  :conditions => ["roles.name = 'manager' and roles.authorizable_type = 'Venue'"]

  
  has_many      :installations,   :order => 'name'
  belongs_to    :sport   
  belongs_to    :marker 
  has_one       :blog  
  

  before_create :format_description
  before_update :format_description
  after_create  :create_venue_blog_details

  # acts_as_authorization_subject

  # method section
  def object_counter(objects)
    @counter = 0
    objects.each { |object|  @counter += 1 }
    return @counter
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
  
  def is_futbol?
   	# sports related to goals
    return [1, 2, 3, 4, 5].include?(self.sport_id)
  end
  
  def is_basket?
   	# sports related to basket
    return [7].include?(self.sport_id)
  end

  def is_group_member_of?(item)
    self.has_role?('member', item)
  end
  
  def self.latest_items(items)
    find(:all, :select => "id, name, photo_file_name, updated_at as created_at", :conditions => ["created_at >= ? and archive = false", LAST_WEEK]).each do |item| 
      items << item
    end
    return items 
  end
  
  def self.latest_updates(items)
    find(:all, :select => "id, name, photo_file_name, updated_at as created_at", :conditions => ["updated_at >= ? and archive = false", LAST_WEEK]).each do |item| 
      items << item
    end
    return items 
  end

  def create_venue_details(user)
    user.has_role!(:manager, self)
    user.has_role!(:creator, self)
    user.has_role!(:member,  self)
  end
  
  def format_description
    self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
  end

private
  def create_venue_blog_details
    @blog = Blog.create_item_blog(self)
  end
end