class Practice < ActiveRecord::Base
end

# 
# class Practice < ActiveRecord::Base
#   # == Schema Information
#   # Schema version: 20080916002106
#   #
#   # Table name: practices
#   #
#   # t.string    :concept
#   # 
#   # t.datetime  :starts_at
#   # t.datetime  :ends_at
#   # t.boolean   :reminder
#   # 
#   # t.integer   :practice_attendees_count,    :default => 0
#   # t.integer   :group_id
#   # t.integer   :user_id
#   # t.integer   :sport_id
#   # t.integer   :marker_id 
#   # t.string    :time_zone
#   # t.text      :description
#   # t.integer   :player_limit
#   # t.boolean   :played,                      :default => false
#   # t.boolean   :privacy,                     :default => true
#   # t.boolean   :archive,                     :default => false
#   # t.timestamps
# 
# 
#   # Authorization plugin
#   acts_as_authorizable
#   # acts_as_paranoid
#   
#   acts_as_solr :fields => [:concept, :description, :time_zone, :starts_at]  if @use_solr #, :include => [:sport, :marker]
#   
#   include ActivityLogger
#   
#   attr_accessible :concept, :description, :starts_at, :ends_at
#   
#   MAX_TITLE_LENGTH = 40
#   MAX_DESCRIPTION_LENGTH = MAX_STRING_LENGTH
#   PRIVACY = { :public => 1, :teammates => 2 }
#   
#   has_one    :forum
#   
#   belongs_to :user
#   belongs_to :group
#   
#   has_many :practice_attendees
#   has_many :attendees, :through => :practice_attendees, :source => :user
#   has_many :comments, :as => :commentable, :order => 'created_at DESC'
#   has_many :activities, :foreign_key => "item_id", :dependent => :destroy, :conditions => "item_type = 'Practice'"
#   
# 
#   validates_presence_of :concept, :starts_at, :ends_at #, :user, :privacy
#   validates_length_of   :concept, :maximum => MAX_TITLE_LENGTH
#   validates_length_of   :description, :maximum => MAX_DESCRIPTION_LENGTH, :allow_blank => true
#   
#   
#   # named_scope :user_practices, lambda { |user| { :conditions => ["user_id = ? OR (privacy = ? OR (privacy = ? AND (user_id IN (?))))", 
#   #   user.id,
#   #   PRIVACY[:public], 
#   #   PRIVACY[:teammates], 
#   #   user.my_users] } 
#   #   }
#   
#   # named_scope :period_practices, lambda { |date_from, date_until| { :conditions => ['starts_at >= ? and starts_at <= ?',
#   #   date_from, date_until] } 
#   # }
# 
#     # after_create :log_activity
# 
#     # def self.monthly_practices(date)
#     #   self.period_practices(date.beginning_of_month, date.to_time.end_of_month)
#     # end
# 
#     # def self.daily_practices(date)
#     #   self.period_practices(date.beginning_of_day, date.to_time.end_of_day)
#     # end
# 
#     # def validate
#     #   if ends_at
#     #     unless starts_at <= ends_at
#     #       errors.add(:starts_at, "can't be later than End Time")
#     #     end
#     #   end
#     # end
# 
#     # def sport
#     #   practice.group.sport
#     # end
#     
#     def attend(user)
#       self.practice_attendees.create!(:user => user)
#     rescue ActiveRecord::RecordInvalid
#       nil
#     end
# 
#     def unattend(user)
#       if practice_attendee = self.practice_attendees.find_by_user_id(user)
#         practice_attendee.destroy
#       else
#         nil
#       end
#     end
# 
#     def attending?(user)
#       self.attendee_ids.include?(user[:id])
#     end
# 
#     def only_teammates?
#       self.privacy == PRIVACY[:teammates]
#     end
# 
#     # private
#     # 
#     # def log_activity
#     #   add_activities(:item => self, :user => self.user)
#     # end
# 
#   end
