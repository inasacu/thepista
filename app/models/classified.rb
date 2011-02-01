class Classified < ActiveRecord::Base

    belongs_to      :table,           :polymorphic => true
    belongs_to      :item,            :polymorphic => true
  
    # validations  
    validates_presence_of         :concept
    validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
    validates_format_of           :concept,                         :with => /^[A-z 0-9 _.-]*$/ 

    validates_presence_of         :description
    validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

    validates_presence_of         :starts_at,     :ends_at

    # variables to access
    attr_accessible :concept, :description, :starts_at, :table_id, :table_type
    
    # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
    has_friendly_id :concept, :use_slug => true, :approximate_ascii => true, 
                     :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show", "petition"]
                     
    before_create       :format_description

    # method section
    def self.latest_items(items)
      find(:all, :select => "id, concept, created_at, table_type, table_id", :conditions => ["created_at >= ? and archive = false", LAST_WEEK]).each do |item| 
        items << item
      end
      return items 
    end
    
    def self.find_classifieds(item, page = 1)
      self.paginate(:all, :conditions => ["table_type = ? and table_id = ?", item.class.to_s, item],
                          :order => 'starts_at DESC', :page => page, :per_page => CLASSIFIEDS_PER_PAGE)
    end
    
    def self.item_classifieds(item)
      find(:all, :conditions => ["table_id = ? and table_type = ?", item, item.class.to_s])
    end   

    def self.upcoming_classifieds(hide_time)
      with_scope :find => {:conditions=>{:starts_at => ONE_WEEK_FROM_TODAY, :archive => false}, :order => "starts_at"} do
        if hide_time.nil?
          find(:all)
        else
          find(:all, :conditions => ["starts_at >= ?", hide_time, hide_time])
        end
      end
    end
    
    def self.find_classified_item(item)
      find(:first, :conditions => ["id = (select max(id) from classifieds where table_id = ? and table_type = ?) ", item, item.class.to_s])
    end

    private

    def format_description
      self.description.gsub!(/\r?\n/, "<br>") unless self.description.nil?
    end

    def set_time_to_utc
      # self.starts_at = self.starts_at.utc
      # self.ends_at = self.ends_at.utc
    end

    def validate
      # self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
      # self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
    end

  end

