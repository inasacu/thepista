class Practice < ActiveRecord::Base

  belongs_to :group
  belongs_to :sport
  belongs_to :marker
  belongs_to :invite_group,   :class_name => "Group",   :foreign_key => "invite_id"

  has_one    :forum

  has_many   :practice_attendees
  has_many   :attendees, :through => :practice_attendees, :source => :user
  
  # has_many   :comments, :as => :commentable, :order => 'created_at DESC'
  # has_many   :activities, :foreign_key => "item_id", :dependent => :destroy, :conditions => "item_type = 'Practice'"
  
  
  
  validates_presence_of       :concept,          :within => NAME_RANGE_LENGTH
  validates_presence_of       :description,      :within => DESCRIPTION_RANGE_LENGTH
  validates_presence_of       :starts_at
  validates_presence_of       :time_zone
  validates_presence_of       :sport_id
  validates_presence_of       :marker_id
  validates_presence_of       :group_id

  # variables to access
  attr_accessible :concept, :starts_at, :ends_at
  attr_accessible :time_zone, :group_id, :sport_id, :marker_id, :player_limit
  attr_accessible :public, :description









  # named_scope :user_practices, lambda { |user| { :conditions => ["user_id = ? OR (privacy = ? OR (privacy = ? AND (user_id IN (?))))", 
  #   user.id,
  #   PRIVACY[:public], 
  #   PRIVACY[:teammates], 
  #   user.my_users] } 
  #   }

  # named_scope :period_practices, lambda { |date_from, date_until| { :conditions => ['starts_at >= ? and starts_at <= ?',
  #   date_from, date_until] } 
  # }


  # def self.monthly_practices(date)
  #   self.period_practices(date.beginning_of_month, date.to_time.end_of_month)
  # end

  # def self.daily_practices(date)
  #   self.period_practices(date.beginning_of_day, date.to_time.end_of_day)
  # end

  
  def validate
    if ends_at
      unless starts_at <= ends_at
        errors.add(:starts_at, "can't be later than End Time")
      end
    end
  end


  def attend(user)
    self.practice_attendees.create!(:user => user)
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def unattend(user)
    if practice_attendee = self.practice_attendees.find_by_user_id(user)
      practice_attendee.destroy
    else
      nil
    end
  end

  #     def attending?(user)
  #       self.attendee_ids.include?(user[:id])
  #     end



  def self.current_practices(user, page = 1)
    self.paginate(:all, 
    :conditions => ["starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.now, user.id],
    :order => 'group_id, starts_at', :page => page, :per_page => PRACTICES_PER_PAGE)
  end

  def self.previous_practices(user, page = 1)
    self.paginate(:all, 
    :conditions => ["starts_at < ? and group_id in (select group_id from groups_users where user_id = ?)", Time.now, user.id],
    :order => 'group_id, starts_at desc', :page => page, :per_page => PRACTICES_PER_PAGE)
  end

  def self.max(practice)
    find(:first, :conditions => ["group_id = ? and played = true", practice.group_id], :order => "starts_at desc")    
  end

  def self.previous(practice, option=false)
    if self.count(:conditions => ["id < ? and group_id = ?", practice.id, practice.group_id] ) > 0
      return find(:first, :select => "max(id) as id", :conditions => ["id < ? and group_id = ?", practice.id, practice.group_id]) 
    end
    return practice
  end 

  def self.next(practice, option=false)
    if self.count(:conditions => ["id > ? and group_id = ?", practice.id, practice.group_id]) > 0
      return find(:first, :select => "min(id) as id", :conditions => ["id > ? and group_id = ?", practice.id, practice.group_id])
    end
    return practice
  end

  def self.upcoming_practices(hide_time)
    with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :played => false}, :order => "starts_at"} do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
      end
    end
  end

  def game_played?
    played == true
  end

  def not_played?
    played == false
  end

  def create_practice_details(user, update_practice=false)
    unless update_practice
      # create forum, topic, post details for practice
      @forum = Forum.create_practice_forum(self)
      @topic = Topic.create_practice_topic(@forum, user)
    else  
      @forum = Forum.find(self.forum)
      @topic = Topic.find(@forum.topics.first)
    end
    Post.create_practice_post(@forum, @topic, user)

    Match.create_practice_match(self) 

    Fee.create_group_fees(self)    
    Fee.create_user_fees(self)
  end

  def create_join_user_practice_details
    Match.create_practice_match(self) 
    Fee.create_user_fees(self)
  end

end