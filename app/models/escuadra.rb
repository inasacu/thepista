# == Schema Information
#
# Table name: escuadras
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  archive            :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  item_id            :integer
#  item_type          :string(255)
#  slug               :string(255)
#  official           :boolean          default(FALSE)
#

class Escuadra < ActiveRecord::Base

	# extend FriendlyId 
	# friendly_id :name, 			use: :slugged
  
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

		validates_presence_of     :name  
		validates_length_of       :name,            :within => NAME_RANGE_LENGTH    

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
  
  
  def self.get_the_current_escuadras(cup)
    find(:all, :conditions => ["archive = false and escuadras.id in 
        (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", cup])
	end
	
	def self.get_users_escuadras(escuadras, users, cup)
    current_cup_escuadras = find(:all, :conditions => ["escuadras.archive = false and escuadras.item_type = 'User' and 
                                escuadras.item_id in (?) and escuadras.id in 
        (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", users, cup])
    
        if current_cup_escuadras.nil? or current_cup_escuadras.empty?
          users.each do |user|
            escuadras << user 
          end
        else
          
          the_escuadra_users = []
          current_cup_escuadras.each do |current_cup_escuadra|
            the_escuadra_users << current_cup_escuadra.item
          end
          
          users.each do |user|
            escuadras << user unless the_escuadra_users.include?(user)
          end
        end

    return escuadras
	end
	

	def self.get_the_user_escuadras(user, cup)
    find(:all, :conditions => ["escuadras.archive = false and escuadras.item_type = 'User' and 
                                escuadras.item_id = ? and escuadras.id in 
        (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", user, cup])
	end
	
	def self.get_the_group_escuadras(group, cup)
    find(:all, :conditions => ["escuadras.archive = false and escuadras.item_type = 'Group' and 
                                escuadras.item_id = ? and escuadras.id in 
        (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", group, cup])
	end

  def self.get_groups_escuadras(escuadras, groups, cup)
    current_cup_escuadras = find(:all, :conditions => ["escuadras.archive = false and escuadras.item_type = 'Group' and 
      escuadras.item_id in (?) and escuadras.id in 
      (select escuadra_id from cups_escuadras where cups_escuadras.archive = false and cups_escuadras.cup_id = ?)", groups, cup])

      groups.each do |group| 
        is_item_available = false
        current_cup_escuadras.each {|escuadra| is_item_available = (escuadra.item_type == 'Group' and escuadra.item == group) ? true : is_item_available }
        escuadras << group unless is_item_available
      end
        return escuadras
  end
				
  def join_escuadra(cup)
    CupsEscuadras.join_escuadra(self, cup)
    Standing.delay.create_cup_escuadra_standing(cup) if USE_DELAYED_JOBS
    Standing.create_cup_escuadra_standing(cup).deliver unless USE_DELAYED_JOBS
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
