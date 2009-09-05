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
      
      def self.previous(user, groups)
        if self.count(:conditions => ["id < ? and id in (select user_id from groups_users where group_id in (?))", user.id, groups] ) > 0
          return find(:first, :select => "max(id) as id", 
          :conditions => ["id < ?  and id in (select user_id from groups_users where group_id in (?))", user.id, groups]) 
        end
          return user
      end 

      def self.next(user, groups)
        if self.count(:conditions => ["id > ? and id in (select user_id from groups_users where group_id in (?))", user.id, groups]) > 0
          return find(:first, :select => "min(id) as id", :conditions => ["id > ?  and id in (select user_id from groups_users where group_id in (?))", user.id, groups])
        end
        return user
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
      
      def is_manager?
        self.has_role?('manager')
      end
      
      def is_maximo?
        self.has_role?('maximo')
      end

    def can_modify?(user)
      user == self or user.has_role?('maximo')
    end
    
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
 
    def self.find_all_by_mates(user)
      find_by_sql(["select distinct users.* from users, groups_users " +
        "where users.id = groups_users.user_id " +
        "and groups_users.group_id in (?) " +
        "and groups_users.user_id != ? " +
        "and users.available = true " +
        "order by name", user.groups, user.id])
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

    
    
    def create_matches(schedule, group, user)
      Match.create_schedule_group_user_match(schedule, group, user)
    end

    def create_user_fees(schedule)
      Fee.create_user_fees(schedule)
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
