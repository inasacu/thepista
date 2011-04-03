class User < ActiveRecord::Base

  index do
    name
    description
    company
  end
   
   # allows user to rate a model 
   ajaxful_rateable :stars => 5, :dimensions => [:evaluation]
   ajaxful_rater
   
   define_completeness_scoring do
     check :phone,                lambda { |per| per.phone.present? },            :high     # => defaults to 60
     check :company,              lambda { |per| per.company.present? },          :medium   # => defaults to 40
     check :description,          lambda { |per| per.description.present? },      :medium   # => defaults to 40
     check :photo_file_name,      lambda { |per| per.photo_file_name? },          :low      # => defaults to 20
   end
   
      
  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email]
    login_field :email
    validate_login_field :false
    UserSession.find_by_login_method = 'find_by_email'
  end
  
  # Validations
  validates_presence_of :email
  validates_length_of   :name,            :within => NAME_RANGE_LENGTH
  validates_inclusion_of   :language,     :in => ['en', 'es'],    :allow_nil => false
  
  # validates_format_of   :name,            :with =>  /^[A-Z a-z 0-9]*\z/
  # validates_acceptance_of :terms_of_service
  # validates_inclusion_of :gender, :in => ['male','female'], :allow_nil => true
  # validates_format_of :email,:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :on => :create #, :message => "es invalido"
 
  before_destroy    :destroy_activities, :destroy_feeds  
  before_destroy    :unmap_rpx
  
  acts_as_authorization_subject
  
  has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>", :large => "500x500>" }, 
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/users/:id/:style.:extension",
    :path => ":assets/users/:id/:style.:extension",
    :default_url => "avatar.png"  
        
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
    validates_attachment_size         :photo, :less_than => 5.megabytes

    belongs_to                :identity_user,   :class_name => 'User',              :foreign_key => 'rpxnow_id'
    
    has_and_belongs_to_many   :groups,                :conditions => 'archive = false',   :order => 'name'
    has_and_belongs_to_many   :challenges,            :conditions => 'archive = false',   :order => 'name'
    
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
    
    has_one     :blog  
    has_many    :feeds

    has_many    :activities,
                :conditions => {:created_at => LAST_THREE_DAYS},
                :order => "created_at DESC",
                :limit => 1

    # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
    has_friendly_id :name, :use_slug => true, :approximate_ascii => true, 
                    :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show", "petition"]
                      
    before_update   :format_description
    after_create    :create_user_blog_details, :deliver_signup_notification
   
       
    # method section   
    def self.looking_for_group(user)
      find(:all, 
      :conditions => ["archive = false and looking = true and time_zone = ?", user.time_zone],
      :order => "last_request_at",
      :limit => LOOKING_GROUPS) 
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
    
    def self.contact_emails(email)
      User.find(:first, :conditions => ["email = ?", email])
    end 
    
    def forum_message?
      self.forum_comment_notification?
    end
    
    def blog_message?
      self.blog_comment_notification?
    end       

    def self.latest_updates(items)
      find(:all, :select => "id, name, photo_file_name, profile_at as created_at", :conditions => ["profile_at >= ?", THREE_WEEKS_AGO], :order => "updated_at desc").each do |item| 
        items << item
      end
      return items 
    end    
    
    def friends
      User.find(:all, :select => "distinct users.*", :joins => "LEFT JOIN groups_users on groups_users.user_id = users.id", 
                      :conditions => ["users.id != ? and groups_users.group_id in (?)", self, self.groups], :order => "users.name")
    end
    
    def self.squad_list(schedule)
      User.find(:all, :select => "distinct users.*, matches.type_id, types.name as types_name", :joins => "LEFT JOIN matches on matches.user_id = users.id LEFT JOIN types on types.id = matches.type_id", 
                      :conditions => ["matches.schedule_id = ?", schedule], :order => "users.name")
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
      # (self == current_user and self.is_not_member_of?(group)) or (current_user.is_manager_of?(group) and self.is_not_member_of?(group))
      (self == current_user and self.is_not_member_of?(group))
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
            is_manager = (self.has_role?('manager', group)) # or self.has_role?('creator', group))
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
            is_manager = (self.has_role?('manager', group)) # or self.has_role?('creator', group))
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
    
    def received_messages(page = 1)
      _received_messages.paginate(:page => page, :per_page => MESSAGES_PER_PAGE)
    end
  
    def sent_messages(page = 1)
      _sent_messages.paginate(:page => page, :per_page => MESSAGES_PER_PAGE)
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
      
    def trashed_messages(page = 1)
      conditions = [%((sender_id = :user AND sender_deleted_at > :t) OR
                      (recipient_id = :user AND recipient_deleted_at > :t)),
                    { :user => id, :t => TRASH_TIME_AGO }]
      order = 'created_at DESC'
      trashed = Message.paginate(:all, :conditions => conditions,
                                       :order => order,
                                       :page => page,
                                       :per_page => MESSAGES_PER_PAGE)
    end
  
    def recent_messages
      Message.find(:all,
                   :conditions => [%(recipient_id = ? AND
                                     recipient_deleted_at IS NULL), id],
                   :order => "created_at DESC",
                   :limit => NUM_RECENT_MESSAGES)
    end
    
    def unread_messages_count
      sql = %(recipient_id = :id
      AND sender_id != :id
      AND recipient_deleted_at IS NULL
      AND recipient_read_at IS NULL)
      conditions = [sql, { :id => id }]
      Message.count(:all, :conditions => conditions)
    end
    
    def has_unread_messages?
      sql = %(recipient_id = :id
              AND sender_id != :id
              AND recipient_deleted_at IS NULL
              AND recipient_read_at IS NULL)
      conditions = [sql, { :id => id }]
      Message.count(:all, :conditions => conditions) > 0
    end
 
    def self.find_all_by_mates(user)
      find_by_sql(["select distinct users.* from users, groups_users " +
        "where users.id = groups_users.user_id " +
        "and groups_users.group_id in (?) " +
        "and groups_users.user_id != ? " +
        "and users.available = true " +
        "order by name", user.groups, user.id])
    end

    def self.find_group_mates(group)
      @recipients = User.find_by_sql(["select distinct users.* from users, groups_users " +
            "where users.id = groups_users.user_id " +
            "and groups_users.group_id in (?) " +
            "and groups_users.user_id != ? " +
            "and users.available = true " +
            "order by name", group.id, self.id])
    end
    
    def object_counter(objects)
      @counter = 0
      objects.each { |object|  @counter += 1 }
      return @counter
    end

    def page_mates(page = 1)  
      mates = User.paginate(:all, 
      :conditions => ["id in (select distinct user_id from groups_users where group_id in (?))", self.groups],
      :order => "name",
      :page => page, 
      :per_page => USERS_PER_PAGE)

      if object_counter(mates) == 0
        mates = User.paginate(:all, 
        :conditions => ["id = ?", self.id],
        :order => "name",
        :page => page, 
        :per_page => USERS_PER_PAGE)
      end
      return mates
    end
    
    def other_mates(page = 1)      
      mates = User.paginate(:all, 
      :conditions => ["archive = false and id not in (select user_id from groups_users where group_id in (?))", self.groups],
      :order => "name",
      :page => page, 
      :per_page => USERS_PER_PAGE)

      if object_counter(mates) == 0
        mates = User.paginate(:all, 
        :conditions => ["id = ?", self.id],
        :order => "name",
        :page => page, 
        :per_page => USERS_PER_PAGE)
      end
      return mates
    end      

    def find_mates                         
      mates = User.find(:all, :conditions => ["id in (select distinct user_id from groups_users where group_id in (?))", self.groups], 
                 :order => "name")
    end
    
    def create_user_fees(schedule)
      Fee.create_user_fees(schedule)
    end
        
    def create_user_blog_details
      @blog = Blog.create_item_blog(self)
    end


  # authlogic and rpxnow
    # Set the login to nil if it was blank so we avoid duplicates on ''.
    # Duplicates of NULL (nil) are allowed.
    def login=(login)
      login = nil if login.blank?
      self[:login] = login
    end

    def rpx_user?
      !identity_url.blank?
    end

    def deliver_signup_notification
      UserMailer.send_later(:deliver_signup_notification, self)
    end
    
    def deliver_password_reset_instructions!  
  		reset_perishable_token!  
      UserMailer.send_later(:deliver_password_reset_instructions, self) 
  	end
  	
    protected

    # We need to cleanup the RPX mapping from RPXNow so that if the user tries
    # to create a new account using RPX in the future, we don't think they should
    # already have one and try to log them in as a deleted User.
    def unmap_rpx
      # api_key = [YOUR API KEY]
      api_key = APP_CONFIG['rpx_api']['key']
      RPXNow.mappings(self[:id], api_key).each do |identifier|
        RPXNow.unmap(identifier, self[:id], api_key)
      end
    end

    # Only validate uniqueness of the login if they are not an RPX user
    # or they have actually specified one. This stops us from finding
    # other RPX users (with NULL logins) as "duplicates".
    def validate_unique_login_with_rpx?
      !rpx_user? || !self.login.blank?
    end

    # We only need to validate format/length of the login if the user is NOT an RPX user
    # or they are trying to set a username or password in their profile.
    def validate_login_with_rpx?
      !rpx_user? || !self.login.blank? || !self.password.blank?
    end

    # We only need to validate the password if the user is NOT an RPX user
    # or they are trying to set a username or password in their profile.
    def validate_password_with_rpx?
      ( !rpx_user? || !self.password.blank? || !self.login.blank? ) && require_password?
    end
    

    private
    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    # openid from authlogic authentication
    def map_openid_registration(registration)
      self.email = registration["email"] if email.blank?
      self.name = registration["nickname"] if name.blank?      
    end

    # Clear out all activities associated with this user.
    def destroy_activities
      Activity.find_all_by_user_id(self).each {|a| a.destroy}
    end

    def destroy_feeds
      Feed.find_all_by_user_id(self).each {|f| f.destroy}
    end
    
  end
