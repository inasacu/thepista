# TABLE "users"
# t.string   "name"
# t.string   "email"                                       
# t.string   "identity_url"
# t.string   "language"                                
# t.string   "time_zone"                               
# t.string   "phone"
# t.string   "login"
# t.boolean  "teammate_notification"                   
# t.boolean  "message_notification"                    
# t.string   "photo_file_name"
# t.string   "photo_content_type"
# t.integer  "photo_file_size"
# t.datetime "photo_updated_at"
# t.string   "crypted_password"
# t.string   "password_salt"
# t.string   "persistence_token"                                          
# t.integer  "login_count"                                  
# t.datetime "last_request_at"
# t.datetime "last_login_at"
# t.datetime "current_login_at"
# t.string   "last_login_ip"
# t.string   "current_login_ip"
# t.boolean  "private_phone"      -- recommend removal                          
# t.boolean  "private_profile"    -- recommend removal                         
# t.string   "gender"
# t.datetime "birth_at"
# t.boolean  "archive"                                 
# t.datetime "created_at"
# t.datetime "updated_at"
# t.string   "perishable_token"                            
# t.datetime "last_contacted_at"
# t.boolean  "active"                                  
# t.datetime "profile_at"    -- recommend removal 
# t.string   "company"                  
# t.boolean  "last_minute_notification"                
# t.integer  "city_id"                                 
# t.string   "email_backup"
# t.string   "sport"
# t.string   "linkedin_url"
# t.string   "linkedin_token"
# t.string   "linkedin_secret"
# t.string   "slug"
# t.boolean	 "validation"
# t.boolean	 "whatsapp"

class User < ActiveRecord::Base

	extend FriendlyId 
	friendly_id :name_slug,				use:  			:slugged 

	def name_slug
		return Base64.urlsafe_encode64("#{name} #{id}")	
	end
	
  acts_as_authentic do |c|
    login_field :email
    UserSession.find_by_login_method = 'find_by_email'

    # c.ignore_blank_passwords = true #ignoring passwords
    # c.validate_password_field = false #ignoring validations for password fields
  end

  # Validations
  validates_presence_of 			:email
  validates_length_of   			:name,            :within => NAME_RANGE_LENGTH
 
  
  # related to gem acl9
  acts_as_authorization_subject :association_name => :roles, :join_table_name => :roles_users
  
  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>", :large => "500x500>" }, 
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :url => "/assets/users/:id/:style.:extension",
    :path => ":assets/users/:id/:style.:extension",
    :default_url => IMAGE_AVATAR  
        
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes

    # belongs_to          :identity_user,   :class_name => 'User',              :foreign_key => 'rpxnow_id'
    belongs_to          :city
    
    has_and_belongs_to_many   :groups,                :conditions => 'groups.archive = false',   :order => 'name'
    has_and_belongs_to_many   :challenges,            :conditions => 'challenges.archive = false',   :order => 'name'
    
		has_many		:authentications
    has_many    :addresses
    has_many    :accounts
    has_many    :payments
  
    has_many    :scorecards, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "group_id"
  
    has_many    :fees
    has_many    :invitations
    has_many    :messages
    has_many    :matches
    has_many    :casts
                
    has_many    :teammates
    
    has_many    :managers,
      :through =>     :teammates,
      :conditions =>  "teammates.status = 'accepted'",
      :order =>       :name
  
    has_many    :requested_managers,
      :through =>     :teammates,
      :source =>      :manager,
      :conditions =>  "teammates.status = 'requested'",
      :order =>       "teammates.created_at"
    
    has_many    :pending_managers,
      :through =>     :teammates,
      :source =>      :manager,
      :conditions =>  "teammates.status = 'pending'",
      :order =>       "teammates.created_at"
    
    has_many    :pending_teams,
      :through =>     :teammates,
      :source =>      :group,
      :conditions =>  "teammates.status = 'pending'",
      :order =>       "teammates.created_at"
    
      
    with_options :class_name => "Message", :dependent => :destroy, :order => "created_at DESC" do |user|
      user.has_many :_sent_messages, :foreign_key => "sender_id", :conditions => "sender_deleted_at IS NULL"
      user.has_many :_received_messages, :foreign_key => "recipient_id", :conditions => "recipient_deleted_at IS NULL"
    end         

		after_create				:signup_notification
       
    # method section  
		def apply_omniauth(omniauth)			
			self.email = omniauth['info']['email'] if omniauth['info']['email']
			self.name = omniauth['info']['name'] if omniauth['info']['name']
			self.photo = omniauth['photo']['email'] if omniauth['info']['photo']
			self.identity_url = omniauth['credentials']['token'] if omniauth['credentials']['token']
		end

	  def self.create_from_omniauth(omniauth)
	    user = User.new(:username => omniauth['user_info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase)
	    user.save(false) #create the user without performing validations. This is because most of the fields are not set.
	    user.reset_persistence_token! #set persistence_token else sessions will not be created
	    user
	  end
	
		def self.find_using_email(email)
			find(:first, :conditions => ["lower(email) = ?", email])
		end
	
    def avatar
      self.photo.url
    end

    def thumbnail
      self.photo.url(:thumb)
    end

    def icon      
      self.photo.url(:icon)
    end 
    
    def medium
      self.photo.url(:medium)
    end

    def has_challenge?
      self.challenges.count > 0
    end

    def has_group?
      self.groups.count > 0
    end
    
    def has_sport?
      self.groups.count > 0
    end

		def has_notification? 			
			self.archive ? (return false) : (return	self.message_notification?) 			
		end
		
		def has_last_minute_notification? 
			if DISPLAY_FREMIUM_SERVICES
				self.archive ? (return false) : (return	self.last_minute_notification?) 	
			else
				return self.has_notification? 
			end
		end		
		
    def email_to_name
      self.name = self.email[/[^@]+/]
      self.name.split(".").map {|n| n.capitalize }.join(" ")
    end

    def my_groups
      @my_groups = []
      self.groups.each { |group| @my_groups << group.id }
      return @my_groups
    end
      
    def my_managers(user)
      is_manager = false
      self.groups.each{ |group| is_manager = user.is_manager_of?(group) } 
      return is_manager
    end

		def self.find_rpx_user(identity, email)
				find(:first, :conditions => ["identity_url = ? or email = ?", identity, email])
    end

    def self.contact_emails(email)
      User.find(:first, :conditions => ["email = ?", email])
    end 

    def self.user_fees(the_users)
			find.where("id in (?) and archive = false", the_users).page(params[:page]).order('users.name')
		end

    def self.latest_updates(items)
      find(:all, :select => "id, name, photo_file_name, profile_at as created_at", :conditions => ["profile_at >= ?", LAST_THREE_DAYS], :order => "updated_at desc").each do |item| 
        items << item
      end
      return items 
    end 

    def self.latest_items(items)
	    find(:all, :conditions => ["created_at >= ? and archive = false", LAST_THREE_DAYS]).each do |item|
        items << item
      end
      return items 
    end   
    
    def friends
      User.find(:all, :select => "distinct users.*", :joins => "LEFT JOIN groups_users on groups_users.user_id = users.id", 
                                        :conditions => ["users.archive = false and users.id != ? and groups_users.group_id in (select distinct group_id from groups_users where user_id = ?)", self, self], :order => "users.name")
    end
    
    def self.squad_list(schedule)
      User.find(:all, :select => "distinct users.*, matches.type_id, types.name as types_name", 
							  :joins => "LEFT JOIN matches on matches.user_id = users.id 
							             LEFT JOIN types on types.id = matches.type_id
													 LEFT JOIN groups_users on groups_users.user_id = users.id", 
                :conditions => ["users.archive = false and matches.schedule_id = ? and groups_users.group_id = ?", schedule, schedule.group], 
								:order => "matches.type_id, users.name")
    end

    def has_item_petition?(current_user, item)
      petition = false      
      if Teammate.count(:conditions => ["accepted_at is null and item_id = ? and item_type = ? and sub_item_id is null and sub_item_type is null and (user_id = ? or manager_id = ?)", 
                                item.id, item.class.to_s, current_user.id, current_user.id]) > 0
          petition = true
      end        
      return (current_user == self and petition)
    end
    
      
    def has_pending_petition?(current_user)
      current_user == self and (!current_user.requested_managers.empty? or !current_user.pending_managers.empty?)
    end
         
    ## methods for acl9 - authorization      
    def can_add_to_group?(current_user, group)
      (is_current_same_as(self) and self.is_not_member_of?(group))
    end  

    def my_members?(user)
      membership = false
      self.groups.each{ |group| membership = user.is_member_of?(group) unless membership } 
      return membership
    end
      
    def is_not_member_of?(group)
      return unless is_member_of?(group)
    end

    def is_member_of?(group)
      self.has_role?('member', group)
    end
      
    def is_user_manager_of?(user)
      is_manager = (self == user) 

      unless is_manager   
        user.groups.each do |group|
          unless is_manager
            is_manager = (self.has_role?('manager', group) or self.has_role?('creator', group))
          end
        end
      end
      
      return is_manager
    end

    def is_group_manager_of?
      is_manager = false

      unless is_manager   
        self.groups.each do |group|
          unless is_manager
            is_manager = (self.has_role?('manager', group) or self.has_role?('creator', group))
          end
        end
      end
      
      return is_manager
    end
    
    def is_user_manager_group(user, group)
      user.is_member_of?(group) and self.has_role?('manager', group)
    end

    def is_user_member_of?(user)
      is_member = (user == self)

      unless is_member
        user.groups.each do |group|
          unless is_member
            is_member = self.has_role?('member', group) 
          end
        end
      end
      
      return is_member
    end

    def is_manager_of?(object)
      self.has_role?('manager', object)
    end

    def is_sub_manager_of?(object)
      self.has_role?('sub_manager', object) or self.has_role?('manager', object)
    end

    def is_subscriber_of?(object)
      self.has_role?('subscription', object) 
    end

    def is_moderator_of?(object)
      self.has_role?('moderator', object) 
    end

    def is_creator_of?(object)
      self.has_role?('creator', object)
    end

    def is_manager?
      self.has_role?('manager')
    end

    def is_maximo?
      self.has_role?('maximo')
    end

    def can_modify?(user)
      user == self or user.has_role?('maximo')
    end
    
		def received_messages(params, page = 1)
			_received_messages.page(params)
		end
		
		def sent_messages(params, page = 1)
			_sent_messages.page(params)
		end

    def find_user_in_conversation(parent_id, exclude_self = true)
      @recipients = []  
      all_users = User.find_by_sql(["select * from users where id in " +
                                  "(select distinct users.id from messages, users " + 
                                    "where messages.parent_id = (select parent_id from messages where id = ?) " +
                                    "and (messages.sender_id = users.id or messages.recipient_id = users.id)) " +
                                    "order by name", parent_id])
  
      all_users.each { |user| @recipients << user unless @recipients.include?(user) or (user == self and exclude_self) }
      return @recipients
    end
               
     def find_message_in_conversation(message)
       messages = []  
       all_messages =  Message.find(:all, 
                        :conditions => ["parent_id in (select parent_id from messages where messages.id = ?) " +
                                       " and ((sender_id = #{self.id} and sender_deleted_at is null) " +
                                       " or (recipient_id = #{self.id} and recipient_deleted_at is null))", message.id])
       all_messages.each { |message| messages << message unless messages.include?(message) }
       return messages
     end
      
      
     def parent_messages(parent_id)
       conditions = [%(((recipient_id = :user AND recipient_deleted_at IS NULL) or (sender_id = :user AND sender_deleted_at IS NULL) and parent_id = :parent_id)),
         { :user => id, :parent_id => parent_id }]     
         parents = Message.find(:all, :conditions => conditions)
       end
      
 
    def self.find_all_by_mates(user)
      find_by_sql(["select distinct users.* from users, groups_users " +
        "where users.id = groups_users.user_id " +
        "and groups_users.group_id in (?) " +
        "and groups_users.user_id != ? " +
        "and users.archive = false " +
        "order by name", user.groups, user.id])
    end

    def self.find_group_mates(group)
      @recipients = User.find_by_sql(["select distinct users.* from users, groups_users " +
            "where users.id = groups_users.user_id " +
            "and groups_users.group_id in (?) " +
            "and users.archive = false " +
            "order by users.name", group])
    end

    def page_mates(page = 1)  
      mates = User.where("id in (select distinct user_id from groups_users where group_id in (?))", self.groups).page(page).order('name')

      if object_counter(mates) == 0
        mates = User.hwere("id = ?", self.id).page(page).order('name')
      end
      return mates
    end
    
    def other_mates(page = 1)      
      mates = User.where("archive = false and id not in (select user_id from groups_users where group_id in (?))", self.groups).page(page).order('name')

      if object_counter(mates) == 0
        mates = User.where("id = ?", self.id).page(name).order("name")
      end
      return mates
    end      

    def find_mates                         
      mates = User.find(:all, :conditions => ["id in (select distinct user_id from groups_users where group_id in (?))", self.groups], :order => "name")
    end
    
    def create_user_fees(schedule)
      Fee.create_user_fees(schedule)  if DISPLAY_FREMIUM_SERVICES
    end

  # authlogic and rpxnow
    # Set the login to nil if it was blank so we avoid duplicates on ''.
    # Duplicates of NULL (nil) are allowed.
    def login=(login)
      login = nil if login.blank?
      self[:login] = login
    end

    def signup_notification
      UserMailer.signup_notification(self).deliver
    end
    
    def password_reset_instructions!  
  		reset_perishable_token!  
      UserMailer.password_reset_instructions(self).deliver
  	end
    
		# def generate_slug
		# 	self.slug = to_param rescue nil
		# end

		# def to_param
		# 	name.to_s.parameterize
		# 	the_encode = "#{self.name}#{self.id}"	
		# 	block_encode =  Base64.urlsafe_encode64(the_encode)
		# 	return block_encode
		# end
		
  end
