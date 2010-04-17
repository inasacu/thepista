class Squad < ActiveRecord::Base

  # friendly url and removes id
  # has_friendly_id :name, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show", "petition"]
  
  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/squads/:id/:style.:extension",
    :path => ":assets/squads/:id/:style.:extension",
    :default_url => "group_avatar.png"

    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes
    
  # validations 
  # validates_uniqueness_of   :name,    :case_sensitive => false
  
  validates_presence_of     :name
  validates_presence_of     :description
  
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
      
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/

  # has_and_belongs_to_many   :cups,          :conditions => 'archive = false',                                 :order => 'name'
  # has_many                  :standings,     :conditions => "squad_id > 0 and played > 0 and archive = false", :order => "squad_id"

  # variables to access
  attr_accessible :name, :photo, :description
  
  # method section
  def avatar
    self.photo.url
  end

  def thumbnail
    self.photo.url
  end

  def icon
    self.photo.url
  end 

  def join_squad(cup)
    CupsSquads.join_squad(self, cup)
  end
  
end
