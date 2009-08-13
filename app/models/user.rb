class User < ActiveRecord::Base
  acts_as_authentic do |c|    
    c.openid_required_fields = [:nickname, :email]

    login_field :email
    validate_login_field :false    
  end

  acts_as_solr :fields => [:name, :time_zone, :position] if use_solr?
  acts_as_authorization_subject
  
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


      belongs_to  :identity_user, :class_name => 'User', :foreign_key => 'rpxnow_id'
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
      
      
    after_create    :create_user_blog_details, :deliver_signup_notification
    

    
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

    def has_group?
      self.groups.count > 0
    end


    
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
      
      def is_not_member_of?(group)
        return unless is_member_of?(group)
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
    #     available == 'No'
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
    #     find(:all, :conditions => "available != 'No'")
    #   end
  



    #   #  queries predefined
    #   def find_group_mates(group)
    #     @recipients = User.find_by_sql(["select distinct users.* from users, groups_users " +
    #           "where users.id = groups_users.user_id " +
    #           "and groups_users.group_id in (?) " +
    #           "and groups_users.user_id != ? " +
    #           "and users.available = true " +
    #           "order by name", group.id, self.id])
    #   end
    # 
    #   def self.find_all_by_mates(user)
    #     find_by_sql(["select distinct users.* from users, groups_users " +
    #           "where users.id = groups_users.user_id " +
    #           "and groups_users.group_id in (?) " +
    #           "and groups_users.user_id != ? " +
    #           "and users.available = true " +
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
      :select => "distinct users.*",
      :joins => "left join groups_users on users.id = groups_users.user_id",
      :conditions => ["groups_users.group_id in (?) or users.id = ?", self.groups, self.id],
      :order => "name",
      :page => page, 
      :per_page => USERS_PER_PAGE)
    end

      def self.user_and_invite(user)
        find_by_sql(["select distinct id as user_id " +
              "from users " +
              "where id = #{user.id} or invited_by_id =  #{user.id}", user.id ])
      end
    
    
      def create_matches(schedule, group, user)
        Match.create_schedule_group_user_match(schedule, group, user)
	  end
    
      def create_user_fees(schedule, group, user)
		Fee.create_schedule_group_user_fee(schedule, group, user)
      end

        
    def create_user_blog_details
      @blog = Blog.create_user_blog(self)
      @entry = Entry.create_user_entry(self, @blog)
      Comment.create_user_comment(self, @blog, @entry)
    end
      

    #   protected
    # 
    #   ## Callbacks
    # 
    #   # Prepare email for database insertion.
    #   def prepare_email
    #     self.email = email.downcase.strip if email
    #   end

  
    
    def deliver_signup_notification
      UserMailer.deliver_signup_notification(self)
    end
    
    def deliver_password_reset_instructions!  
  		reset_perishable_token!  
  		UserMailer.deliver_password_reset_instructions(self)  
  	end

    private

    def map_openid_registration(registration)
      self.email = registration["email"] if email.blank?
      self.name = registration["nickname"] if name.blank?
    end

  end
