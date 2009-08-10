class User < ActiveRecord::Base
  acts_as_authentic do |c|    
    c.openid_required_fields = [:nickname, :email]

    login_field :email
    validate_login_field :false    
  end

  acts_as_solr :fields => [:name, :time_zone, :position] if use_solr?
  
  has_attached_file :photo,
  :styles => {
    :thumb  => "80x80#",
    :medium => "160x160>",
    },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :url => "/assets/users/:id/:style.:extension",
    :path => ":assets/users/:id/:style.:extension",
    # :path => ":attachment/:id/:style.:extension",
    :bucket => 'thepista_desarrollo', 
    :default_url => "avatar.png"  

    def avatar
      self.photo.url
    end

    def thumbnail
      self.photo.url
    end

    def icon
      self.photo.url
    end 

    def has_group?
      self.groups.count > 0
    end


    ###################################### original source 
    # 
    # 
    # require 'digest/sha1'
    # require 'gravatar'
    # 
    # class User < ActiveRecord::Base
    # 
    #   # Authorization plugin
    #   acts_as_authorized_user
    #   acts_as_authorizable
    #   acts_as_paranoid
    #   

    #   
    #   include ActivityLogger
    #   include Authentication
    #   include Authentication::ByCookieToken
    #   
    #   # variables
    #   # USERS_PER_PAGE = 10
    #   # MESSAGES_PER_PAGE = 100
    #   # NUM_RECENT_MESSAGES = 4
    #   # NUM_WALL_COMMENTS = 10
    #   # NUM_RECENT = 8
    #   # TRASH_TIME_AGO = 1.month.ago
    #   # FEED_SIZE = 15
    #   # MAX_NAME = 40
    #   # MAX_DESCRIPTION = 5000
    #   # ONE_WEEK_FROM_TODAY = Time.now - 1.day..Time.now + 7.days
    #   # EMAIL_REGEX = /\A[A-Z0-9\._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
    #   # TIME_AGO_FOR_MOSTLY_ACTIVE = 1.month.ago
    #   # N_COLUMNS = 4
    #   # RASTER_PER_PAGE = 3 * N_COLUMNS
    #   
    #   validates_uniqueness_of     :identity_url
    #   validate                    :normalize_identity_url
    #   validates_presence_of       :email
    #   validates_format_of         :email,                       :with => EMAIL_REGEX
    #   validates_length_of         :name,                        :maximum => MAX_NAME
    #   validates_length_of         :description,                 :maximum => MAX_DESCRIPTION
    #   # validates_format_of         :name,                        :with => /^[A-Z0-9_]$/i, :message =>"must contain only letters, numbers and underscores"
    # 
    #   # validates_numericality_of   :technical,   :less_than => 6
    #   # validates_numericality_of   :physical,    :less_than => 6
    # 
    #   # HACK HACK HACK -- how to do attr_accessible from here?
    #   # prevents a user from submitting a crafted form that bypasses activation
    #   # anything else you want your user to change should be added here.
    #   attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :nickname, :rpxnow_id 
    #   attr_accessible :language, :country, :time_zone, :phone, :default_available, :default_reliable
    #   attr_accessible :terms, :position, :dorsal, :technical, :physical, :injury, :injury_until, :private_email, :private_phone, :private_profile
    #   attr_accessible :teammate_notification, :message_notification, :blog_comment_notification, :forum_comment_notification
    #   attr_accessible :birth_at, :interest, :gender, :description
    #   attr_accessible :openid_login, :provider
    # 
      belongs_to  :identity_user, :class_name => 'User', :foreign_key => 'rpxnow_id'
    # 
    #   # Paperclip
    #   # if production?
    #   #   has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },
    #   #                             :url => "/assets/users/:id/:style/:basename.:extension", 
    #   #                             :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
    #   # else
    #   #   has_attached_file :photo, :url => "/assets/users/:id/:style/:basename.:extension",
    #   #                             :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"  
    #   # end
    #   
    #   # has_attached_file :photo,
    #   #   :styles => {
    #   #     :thumb  => "80x80#",
    #   #     :medium => "160x160>",
    #   #   },
    #   #   :storage => :s3,
    #   #   :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    #   #   :path => ":attachment/:id/:style.:extension",
    #   #   :bucket => 'thepista_desarrollo'
    #   
    # 
    #   # has_attached_file :photo, :default_url => "default_avatar.jpg"  
    #   # validates_attachment_size         :photo, :less_than => 5.megabytes
    #   # validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
    #   
    #   attr_accessible :photo
    #   
      has_and_belongs_to_many   :groups,         :join_table => "groups_users" , :order => "name"
        
      has_many    :addresses
      has_many    :accounts
      has_many    :payments
    
      has_many    :scorecards, :conditions => "user_id > 0 and played > 0 and archive = false", :order => "group_id"
    
      has_many    :fees
      has_many    :invitations
      has_many    :messages
      has_many    :matches
    
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
      
      
    after_create    :create_user_blog_details
    
    #   has_many    :feeds
    #   
    #   has_many    :activities,
    #               :conditions => {:created_at => ONE_WEEK_FROM_TODAY},
    #               :order => "created_at DESC",
    #               :limit => FEED_SIZE
    # 
    #   before_update     :set_old_description
    #   after_update      :log_activity_description_changed
    #   before_destroy    :destroy_activities, :destroy_feeds  
    #   before_validation :prepare_email, :handle_nil_description
    # 
    #   # def self.search(search)
    #   #   if search
    #   #     find_by_solr("#{search}"])
    #   #   else
    #   #     find(:all)
    #   #   end
    #   # end
    #   
    #   # method of acts_as_solr
    #   def is_active
    #     return  self.archive? ? false : true
    #   end
    #   
    #   ## methods for images  
    #   def the_avatar    
    #       # self.photo.url
    #       return "default_avatar.jpg"
    #   end
    # 
    #   def main_photo
    #     the_avatar
    #   end
    # 
    #   def thumbnail
    #     the_avatar
    #   end
    # 
    #   def bounded_icon
    #     the_avatar
    #   end
    #   
    #   def icon
    #     the_avatar
    #   end
    # 
    #   def image
    #     the_avatar
    #   end
    #   
    #   def missing_avatar
    #     self.default_avatar.blank? or self.default_avatar == "default_avatar.jpg"
    #   end
      
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
    
      def my_users
        @my_users = []
        self.groups.each do |group| ; group.users.each { |user| @my_users << user.id unless @my_users.include?(user.id) } ; end
        return @my_users
      end
      
    #   def self.previous(user, groups)
    #       find_by_sql(["select max(user_id) as id from groups_users where user_id < ? and group_id in (?)", user.id, groups])
    #   end 
    #   
    #   def self.next(user, groups)
    #       find_by_sql(["select min(user_id) as id from groups_users where user_id > ? and group_id in (?)", user.id, groups])
    #   end
    #   
    #   def admin?
    #     false
    #   end
         
      ## methods for acts_as_authorizable    
      def my_members?(user)
          membership = false
        self.groups.each{ |group| membership = user.is_member_of?(group) unless membership } 
        return membership
      end
      
      def is_member_of?(group)
        self.has_role?('member', group)
      end
    
      def is_manager_of?(group)
        self.has_role?('manager', group) or self.has_role?('creater', group)
      end
    
      def is_sub_manager_of?(group)
        self.has_role?('sub_manager', group) or self.has_role?('manager', group)
      end
    
      def is_subscriber_of?(group)
        self.has_role?('subscription', group) 
      end
    
      def is_moderator_of?(group)
        self.has_role?('moderator', group) 
      end
      
    #   def self.is_novice?
    #     created_at == updated_at
    #   end
    # 
    def can_modify?(user)
      user == self or user.has_role?('maximo')
    end
    # 
    # 
    #   def beta?
    #     !beta_code.nil?
    #   end
    # 
    #   def unavailable?
    #     default_available == 'No'
    #   end
    # 
    #   def is_phone_private?
    #     !private_phone && !phone.blank?
    #   end
    # 
    # 
    #   def is_user?(user)
    #     self == user
    #   end
  
    
    ## messsage methods
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
    
    def has_unread_messages?
      sql = %(recipient_id = :id
              AND sender_id != :id
              AND recipient_deleted_at IS NOT NULL
              AND recipient_read_at IS NULL)
      conditions = [sql, { :id => id }]
      Message.count(:all, :conditions => conditions) > 0
    end
      
      
    #   # match availability
    #   def self.available_schedule(schedule)
    #     find(:all, 
    #       :conditions => ["id in (select user_id from matches where schedule_id = ? and available = 0)",
    #         schedule.id],
    #       :order => 'name')
    #   end
    #   
    #   def self.not_available_schedule(schedule)
    #     find(:all, 
    #       :conditions => ["id in (select user_id from matches where schedule_id = ? and available = 1)",
    #         schedule.id],
    #       :order => 'name')
    #   end
    #   
    #   def self.maybe_available_schedule(schedule)
    #     find(:all, 
    #       :conditions => ["id in (select user_id from matches where schedule_id = ? and available = 1)",
    #         schedule.id],
    #       :order => 'name')
    #   end
    #       
    #   # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    #   def self.authenticate(login, password)
    #     u = find :first, :conditions => ['login = ?', login] # need to get the salt
    #     u && u.authenticated?(password) ? u : nil
    #   end
    # 
    #   def remember_token?
    #     remember_token_expires_at && Time.now.utc < remember_token_expires_at
    #   end
    # 
    #   # These create and unset the fields required for remembering users between browser closes
    #   def remember_me
    #     remember_me_for 2.weeks
    #   end
    # 
    #   def remember_me_for(time)
    #     remember_me_until time.from_now.utc
    #   end
    # 
    #   def remember_me_until(time)
    #     self.remember_token_expires_at = time
    #     self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    #     save(false)
    #   end
    # 
    #   def forget_me
    #     self.remember_token_expires_at = nil
    #     self.remember_token            = nil
    #     save(false)
    #   end
    # 
    #   # def is_same_user(user)
    #   #   (self.id.to_i == user.id.to_i)
    #   # end
    # 
    #   def not_in_group?
    #     GroupsUsers.find(:first, :conditions => ["user_id = ? or user_id = ?", self.id, self.invited_by_id]).nil?
    #   end
    # 
    #   def self.names
    #     find(:all, :select => "name").map(&:name)
    #   end
    # 
    #   def self.available
    #     find(:all, :conditions => "default_available != 'No'")
    #   end
    # 
    #   def age
    #     (Time.now.year - birthday.year) - (turned_older? ? 0 : 1) rescue 0
    #   end
    # 
    #   def next_birthday
    #     birthday.to_time.change(:year => (turned_older? ? 1.year.from_now : Time.now).year)
    #   end
    # 
    #   def turned_older?
    #     (birthday.to_time.change(:year => Time.now.year) <= Time.now)
    #   end
    # 
    #   #  queries predefined
    #   def find_group_mates(group)
    #     @recipients = User.find_by_sql(["select distinct users.* from users, groups_users " +
    #           "where users.id = groups_users.user_id " +
    #           "and groups_users.group_id in (?) " +
    #           "and groups_users.user_id != ? " +
    #           "and users.default_available = true " +
    #           "order by name", group.id, self.id])
    #   end
    # 
    #   def self.find_all_by_mates(user)
    #     find_by_sql(["select distinct users.* from users, groups_users " +
    #           "where users.id = groups_users.user_id " +
    #           "and groups_users.group_id in (?) " +
    #           "and groups_users.user_id != ? " +
    #           "and users.default_available = true " +
    #           "order by name", user.groups, user.id])
    #   end
    # 
    #   
    #   def find_mates                         
    #     mates = User.find(:all, :select => "distinct users.id, users.identity_url, users.name, users.email, users.time_zone, users.phone, " +
    #                           "users.photo_file_name, users.photo_content_type, users.photo_file_size",
    #                           :joins => "left join groups_users on users.id = groups_users.user_id",
    #                           :conditions => ["groups_users.group_id in (?)", self.groups],
    #                           :group => "users.id, users.identity_url, users.name, users.email, users.time_zone, users.phone, " +
    #                                                 "users.photo_file_name, users.photo_content_type, users.photo_file_size")
    #                                                 # ,
    #                                                 #                           :order => "group_id, users.name")
    #   end
      
    def page_mates(page = 1)                                 
      mates = User.paginate(:all, 
      :joins => "left join groups_users on users.id = groups_users.user_id",
      :conditions => ["groups_users.group_id in (?) or users.id = ?", self.groups, self.id],
      :order => "name",
      :page => page, 
      :per_page => USERS_PER_PAGE)
    end

    #   def self.user_and_invite(user)
    #     find_by_sql(["select distinct id as user_id " +
    #           "from users " +
    #           "where id = #{user.id} or invited_by_id =  #{user.id}", user.id ])
    #   end
    # 
    # 
    #   def create_user_details
    #     Address.create(:user_id => self.id) if Address.find_by_user_id(self.id).nil?
    #   end
    # 
    #   def create_matches(schedule, current_group)
    #     team = Team.find(:first, :conditions=>["group_id = ?", current_group.id])
    #     Match.create(:schedule_id => schedule.id, :team_id => team.id, :user_id => self.id) if Match.find(:first, :conditions =>["schedule_id = ? and team_id = ? and user_id = ?",  schedule.id, team.id, self.id]).nil?
    #   end
    # 
    #   def create_user_fees(schedule, current_group)
    #     Fee.create(:concept => schedule.concept, :schedule_id => schedule.id, :user_id => self.id,
    #       :group_id => current_group.id, :user_fee => true, :actual_fee => schedule.fee_per_game) if Fee.find(:first, :conditions =>["schedule_id = ? and user_id = ? and group_id = ?", schedule.id, self.id, current_group.id]).nil?
    #   end
    #   
    #   # for use with RPX Now gem
    #   def self.find_or_initialize_with_rpx(data)
    #     identifier = data['identifier']
    # 
    #     @user = User.find_by_identity_url(identifier)
    # 
    #     # For extra safeguard to make sure that the first user (who is an admin, who didn't sign up rpx, isn't returned)
    #     unless identifier.nil? || identifier.blank?
    #       u = self.find_by_identity_url(identifier)
    #       if u.nil?
    #         u = self.new
    #         u.read_rpx_response(data)
    #       else
    #         u.id = @user.id  
    #         u.time_zone ||= Time.zone
    #         u.time_zone = @user.time_zone unless @user.time_zone.to_s.empty?        
    #       end
    #     end
    # 
    #     return u
    #   end
    # 
    #   def read_rpx_response(user_data)
    #     
    #       self.identity_url = user_data['identifier']
    #       self.openid_login = true
    #       
    #     case user_data['providerName']
    #     # when "MyOpenID"    
    #       # {"address"=>{"country"=>"Philippines"}, "verifiedEmail"=>"username@gmail.com", "displayName"=>"Yags", 
    #       #                "preferredUsername"=>"Yags", "url"=>"http://username.myopenid.com/", "gender"=>"male", 
    #       #                "utcOffset"=>"08:00", "birthday"=>Sun, 05 Dec 1982, "providerName"=>"MyOpenID", 
    #       #                "identifier"=>"http://username.myopenid.com/", "email"=>"username@gmail.com"}
    #       
    #     when "Facebook"
    #       # {"photo"=>"http://profile.ak.facebook.com/v279/631/23/n532614338_9399.jpg", "name"=>{"givenName"=>"Yags", 
    #       #             "familyName"=>"Balls", "formatted"=>"Yags Balls"}, "displayName"=>"Yags Balls", 
    #       #             "preferredUsername"=>"YagsBalls", "url"=>"http://www.facebook.com/profile.php?id=213144516", 
    #       #             "gender"=>"male", "utcOffset"=>"08:00", "birthday"=>Sun, 05 Dec 1982, 
    #       #             "providerName"=>"Facebook", "identifier"=>"http://www.facebook.com/profile.php?id=315164708"}
    #       self.default_avatar = user_data['photo'] unless user_data['photo'].nil?
    #       self.email = user_data['verifiedEmail'] || user_data['email']
    #       self.name = user_data['givenName'] || user_data['displayName']
    # 
    #     # when "Google"
    #       #   {"verifiedEmail"=>"username@gmail.com", "displayName"=>"username", "preferredUsername"=>"username", 
    #       #             "providerName"=>"Google", 
    #       #             "identifier"=>"https://www.google.com/accounts/o8/id?id=AItOaekQigFV6AKAd8XpaIa1r8rEOdQiib40wWX", 
    #       #             "email"=>"username@gmail.com"}
    #     # when "Yahoo!"
    #       #  {"verifiedEmail"=>"username@yahoo.com", "displayName"=>"Yags T", "preferredUsername"=>"Yags T", 
    #       #             "gender"=>"male", "utcOffset"=>"08:00", "providerName"=>"Yahoo!", 
    #       #             "identifier"=>"https://me.yahoo.com/a/xa.oZ0oHLmBUYd0cVo-#38", 
    #       #             "email"=>"username@yahoo.com"}
    # 
    #     else
    #       #For actual responses, see http://pastie.org/382356
    #       self.default_avatar = user_data['photo'] # unless user_data['photo'].nil?
    #       self.email = user_data['verifiedEmail'] || user_data['email']
    #       # self.gender = user_data['gender']
    #       # self.birth_date = user_data['birthday']
    #       self.name = user_data['givenName'] || user_data['displayName']
    #       # self.last_name = user_data['familyName']
    #       self.login = user_data['preferredUsername']
    #       # self.country = user_data['address']['country'] unless user_data['address'].nil?
    # 
    #     end
    #   end
        
    def create_user_blog_details
      @blog = Blog.create_user_blog(self)
      @entry = Entry.create_user_entry(self, @blog)
      Comment.create_user_comment(self, @blog, @entry)
    end
      
    #   def get_gravatar
    #     theGravatar = Gravatar.new(self.email)
    #     if theGravatar.has_gravatar? and self.default_avatar != theGravatar.url
    #       self.default_avatar = theGravatar.url 
    #       self.has_gravatar = true              
    #       self.save!
    #     else 
    #       self.has_gravatar = false
    #       self.default_avatar = "default_avatar.jpg" 
    #       self.save!
    #     end
    #   end
    # 
    #   protected
    # 
    #   ## Callbacks
    # 
    #   # Prepare email for database insertion.
    #   def prepare_email
    #     self.email = email.downcase.strip if email
    #   end
    # 
    #   # Handle the case of a nil description.
    #   # Some databases (e.g., MySQL) don't allow default values for text fields.
    #   # By default, "blank" fields are really nil, which breaks certain
    #   # validations; e.g., nil.length raises an exception, which breaks
    #   # validates_length_of.  Fix this by setting the description to the empty
    #   # string if it's nil.
    #   def handle_nil_description
    #     self.description = "" if description.nil?
    #   end
    #   
    #   def set_old_description
    #     @old_description = User.find(self).description
    #   end
    # 
    #   def log_activity_description_changed
    #     unless @old_description == description or description.blank?
    #       add_activities(:item => self, :user => self)
    #     end
    #   end
    #   
    #   # Clear out all activities associated with this user.
    #   def destroy_activities
    #     Activity.find_all_by_user_id(self).each {|a| a.destroy}
    #   end
    #   
    #   def destroy_feeds
    #     Feed.find_all_by_user_id(self).each {|f| f.destroy}
    #   end
    #   
    # 
    #   def normalize_identity_url
    #     self.identity_url = OpenIdAuthentication.normalize_identifier(identity_url) unless identity_url.blank?
    #   rescue URI::InvalidURIError
    #     errors.add_to_base("Invalid OpenID URL")
    #   end
    # 
    #   def self.random_string(len)
    #     #generate a random password consisting of strings and digits
    #     chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    #     newpass = ""
    #     1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    #     return newpass
    #   end
    # 
    #   def generate_beta_code
    #     self.beta_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    #   end
    # 
    #   
    #   class << self
    #   
    #     # Return the conditions for a user to be active.
    #     # def conditions_for_active
    #     #   [%(deactivated = ? AND 
    #     #      (email_verified IS NULL OR email_verified = ?)),
    #     #    false, true]
    #     # end
    #     
    #     # Return the conditions for a user to be 'mostly' active.
    #     def conditions_for_mostly_active
    #       [%((last_logged_in_at IS NOT NULL AND
    #           last_logged_in_at >= ?)),
    #        false, true, TIME_AGO_FOR_MOSTLY_ACTIVE]
    #     end
    #   end

    private

    def map_openid_registration(registration)
      self.email = registration["email"] if email.blank?
      self.name = registration["nickname"] if name.blank?
    end

  end
