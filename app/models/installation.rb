class Installation < ActiveRecord::Base
  
    index{ name }

    has_attached_file :photo, :styles => {:icon => "25x25>", :thumb  => "80x80>", :medium => "160x160>",  },
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :url => "/assets/installations/:id/:style.:extension",
      :path => ":assets/installations/:id/:style.:extension",
      :default_url => "group_avatar.png"  

      validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg']
      validates_attachment_size         :photo, :less_than => 5.megabytes

    # has_many        :fees,                                                  :dependent => :destroy 
    # has_one         :forum,                                                 :dependent => :destroy

    belongs_to      :venue
    belongs_to      :marker
    belongs_to      :sport  
    has_many        :reservations
    has_many        :timetables,        :order => "timetables.type_id, timetables.starts_at"

    # validations  
    validates_presence_of         :name
    validates_length_of           :name,                            :within => NAME_RANGE_LENGTH

    validates_presence_of         :description
    validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

    validates_presence_of         :fee_per_pista,  :fee_per_lighting, :timeframe
    validates_numericality_of     :fee_per_pista,  :fee_per_lighting, :timeframe
    validates_presence_of         :starts_at,     :ends_at 

    # variables to access
    attr_accessible :name, :description, :conditions, :starts_at, :ends_at, :timeframe
    attr_accessible :fee_per_pista, :fee_per_lighting, :venue_id, :sport_id, :marker_id
    attr_accessible :public, :lighting, :outdoor, :archive, :photo


    # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
    has_friendly_id :venue_and_name, :use_slug => true, :approximate_ascii => true, 
                     :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

    # after_update        :save_matches
    before_create       :format_description, :format_conditions
    before_update       :format_description, :format_conditions

    # method section
    def venue_and_name
      "#{venue.name} #{name}"
    end
    
    def self.current_installations(venue, page = 1)
      self.paginate(:all, :conditions => ["venue_id = ?", venue], :order => 'name', :page => page, :per_page => INSTALLATIONS_PER_PAGE)
    end
    
    private

    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def format_conditions
      self.conditions.gsub!(/\r?\n/, "<br>") unless self.conditions.nil?
    end

    def validate
      if self.archive == false
        # self.errors.add(:reminder_at, I18n.t(:must_be_before_starts_at)) if self.reminder_at >= self.starts_at 
        self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
        self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at 
      end
    end

  end

