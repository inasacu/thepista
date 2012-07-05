class Escuadra < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name, 			use: :slugged
  
  belongs_to    :item,          :polymorphic => true
  belongs_to    :sub_item,      :polymorphic => true
    
  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :url => "/assets/escuadras/:id/:style.:extension",
    :path => ":assets/escuadras/:id/:style.:extension",
    :default_url => IMAGE_GROUP_AVATAR

    
    
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes
     
  # validations 
  # validates_uniqueness_of   :name,    :case_sensitive => false
  
  validates_presence_of     :name
  validates_presence_of     :description
  
  validates_length_of       :name,            :within => NAME_RANGE_LENGTH
  validates_length_of       :description,     :within => DESCRIPTION_RANGE_LENGTH
      
  validates_format_of       :name,            :with => /^[A-z 0-9 _.-]*$/

  has_and_belongs_to_many   :cups,          :conditions => 'cups.archive = false',   :order => 'name'

  # variables to access
  attr_accessible :name, :photo, :description, :slug
  
  
   
                   
                   
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
  
  def join_escuadra(cup)
    CupsEscuadras.join_escuadra(self, cup)
    Standing.create_cup_escuadra_standing(cup)  
  end
  
  def self.cup_escuadras(cup, page = 1)
    self.where("id in (select escuadra_id from cups_escuadras where cup_id = ?)", cup).page(page).order('name')
  end
  
  private
  # Return true if the cup and item nil
  def self.item_exists?(item)
    find_by_item_id_and_item_type(item, item.class.to_s).nil?
  end
end
