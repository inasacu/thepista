class Classified < ActiveRecord::Base

    include ActivityLogger

    belongs_to     :table,          :polymorphic => true
  
    # validations  
    validates_presence_of         :concept
    validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
    validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/ 

    validates_presence_of         :description
    validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

    validates_presence_of         :starts_at,     :ends_at

    # variables to access
    attr_accessible :concept, :description, :starts_at, :table_id, :table_type

    # friendly url and removes id
    # has_friendly_id :concept, :use_slug => true, :reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

    before_create       :format_description

    after_create        :log_activity
    after_update        :log_activity_played

    # method section
    def self.find_classifieds(group, page = 1)
      self.paginate(:all, 
      :conditions => ["table_type = 'Group' and table_id = ?", group.id],
      :order => 'starts_at DESC', :page => page, :per_page => CLASSIFIEDS_PER_PAGE)
    end
    
    # def self.current_classifieds(user, page = 1)
    #   self.paginate(:all, 
    #   :conditions => ["starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, user.id],
    #   :order => 'starts_at, group_id', :page => page, :per_page => CLASSIFIEDS_PER_PAGE)
    # end

    # def self.previous_classifieds(user, page = 1)
    #   self.paginate(:all, 
    #   :conditions => ["starts_at < ? and group_id in (select group_id from groups_users where user_id = ?)", Time.zone.now, Time.zone.now, user.id],
    #   :order => 'starts_at desc, group_id', :page => page, :per_page => CLASSIFIEDS_PER_PAGE)
    # end

    # def self.previous(classified, option=false)
    #   if self.count(:conditions => ["id < ? and group_id = ?", classified.id, classified.group_id] ) > 0
    #     return find(:first, :select => "max(id) as id", :conditions => ["id < ? and group_id = ?", classified.id, classified.group_id]) 
    #   end
    #   return classified
    # end 

    # def self.next(classified, option=false)
    #   if self.count(:conditions => ["id > ? and group_id = ?", classified.id, classified.group_id]) > 0
    #     return find(:first, :select => "min(id) as id", :conditions => ["id > ? and group_id = ?", classified.id, classified.group_id])
    #   end
    #   return classified
    # end

    def self.upcoming_classifieds(hide_time)
      with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :archive => false}, :order => "starts_at"} do
        if hide_time.nil?
          find(:all)
        else
          find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
        end
      end
    end

    private

    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def set_time_to_utc
      # self.starts_at = self.starts_at.utc
      # self.ends_at = self.ends_at.utc
    end

    def log_activity
      # add_activities(:item => self, :user => self.group.all_the_managers.first) 
    end

    def log_activity_played
      # add_activities(:item => self, :user => self.group.all_the_managers.first) if self.played?
    end

    def validate
      # self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      # self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
    end

  end

