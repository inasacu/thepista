class Fee < ActiveRecord::Base
  
  has_friendly_id :concept, :use_slug => true, 
                  :reserved => ["new", "create", "index", "list", "edit", "update", "destroy", "show"]

  belongs_to     :manager,        :class_name => 'User',        :foreign_key => 'manager_id'
  belongs_to     :debit,          :polymorphic => true
  belongs_to     :credit,         :polymorphic => true
  belongs_to     :item,           :polymorphic => true
  has_many       :payments
  
  # validations  
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH
  
  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH
  
  validates_presence_of         :debit_amount
  validates_numericality_of     :debit_amount

  # variables to access
  attr_accessible :concept, :description, :payed 
  attr_accessible :debit_amount, :season_player
  attr_accessible :debit_id, :debit_type, :credit_id, :credit_type, :item_id, :item_type 
  attr_accessible :type_id, :manager_id
  
  def self.get_debit_fees(debit, credits, page=1)
    paginate(:all, 
             :conditions => ["debit_id = ? and debit_type = ? and 
                              credit_id in (?) and credit_type = ? and type_id = 1 and season_player = false and archive = false", 
                              debit.id, debit.class.to_s, credits, 'Group'],
             :order => 'created_at DESC', 
             :page => page,
             :per_page => FEES_PER_PAGE)
  end
  
  def self.debit_amount(debit, credits)
    @fee = find(:first, :select => "sum(debit_amount) as debit_amount", 
          :conditions => ["debit_id = ? and debit_type = ? and credit_id in (?) and credit_type = ? and 
                          type_id = 1 and season_player = false and archive = false", 
                          debit.id, debit.class.to_s, credits, 'Group'])

      if @fee.nil? or @fee.blank? 
        @fee.debit_amount = 0.0
      end
      return @fee
    end
  
  def self.set_season_player(debit, credit, flag)
    @fees = find(:all, 
                 :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ? and item_type = 'Schedule'", 
                                  debit, debit.class.to_s, credit, credit.class.to_s])    
    @fees.each do |fee|
      
      # set subscription to flag status
      fee.update_attribute(:season_player, flag)
        
      # unless flag is true then user does not has a subscription   
      # and if user has played match then set season_player to false to that it gets charged...
      unless flag
        fee.update_attribute(:season_player, !(fee.type_id == 1))
      end
    end    
  end


  def self.create_user_fees(schedule)    
    schedule.group.users.each do |user|
      type_id = 3
      season_player = user.is_subscriber_of?(schedule.group)
      
      @match = Match.find_by_schedule_id_and_user_id(schedule, user)
      type_id = @match.type_id unless @match.nil?
      
      if self.schedule_user_exists?(schedule, user)        
        self.create!(:concept => schedule.concept, :description => schedule.description,
                      :season_player => season_player,
                      :debit_amount => schedule.fee_per_game,
                      :debit_id => user.id, :credit_id => schedule.group_id, :item_id => schedule.id, 
                      :debit_type => 'User', :credit_type => 'Group', :item_type => 'Schedule',
                      :type_id => type_id)
      else        
        self.find(:first, :conditions => ["debit_id = ? and debit_type = 'User' and item_id = ? and item_type = 'Schedule'", 
          user.id, schedule.id]).update_attributes!(:debit_amount => schedule.fee_per_game, :type_id => type_id)       
      end
    end
  end

  def self.create_group_fees(schedule)
    if self.schedule_group_exists?(schedule)
      self.create!(:concept => schedule.concept, :description => schedule.description, 
                   :debit_amount => schedule.fee_per_pista,
                   :debit_id => schedule.group_id, :credit_id => schedule.group.marker_id, :item_id => schedule.id, 
                   :debit_type => 'Group', :credit_type => 'Marker', :item_type => 'Schedule')
    else
      self.find(:first, :conditions => ["debit_id = ? and debit_type = 'Group' and item_id = ? and item_type = 'Schedule'", 
        schedule.group, schedule]).update_attributes!(:debit_amount => schedule.fee_per_pista)       

    end
  end
  

	
  # return ture if the schedule user group conbination is nil
  def self.schedule_group_user_exists?(schedule, user)
		find_by_schedule_id_and_group_id_and_user_id(schedule, schedule.group, user).nil?
	end 
	
   # Return true if the schedule user combination exist
   def self.schedule_user_exists?(schedule, user)
     find_by_schedule_id_and_user_id(schedule, user).nil?
   end
	
  # Return true if the schedule user combination exist
  def self.schedule_group_exists?(schedule)
    find(:first, :conditions => ["schedule_id = ? and group_id = ? and user_id is null", schedule, schedule.group]).nil?
  end

end