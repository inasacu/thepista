class Fee < ActiveRecord::Base


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
  
  # friendly url and removes id  
  has_friendly_id :concept, :use_slug => true, :reserved => ["new", "create", "index", "list", "edit", "update", "destroy", "show"]
                  
  def self.debit_fees(debits, credits, page=1)
    paginate(:all,
             :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
             :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
                              fees.credit_id in (?) and fees.credit_type = ? and matches.type_id = 1 and fees.season_player = false and fees.archive = false", 
                              debits, 'User', credits, 'Group'],
             :order => 'fees.item_type, fees.item_id', 
             :page => page,
             :per_page => FEES_PER_PAGE)
  end
  
  def self.debit_amount(debits, credits)
    @fee = find(:first, :select => "sum(debit_amount) as debit_amount", 
    :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
    :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and fees.credit_id in (?) and fees.credit_type = ? and 
      matches.type_id = 1 and fees.season_player = false and fees.archive = false", 
      debits, 'User', credits, 'Group'])

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
      type_id = 3
      @match = Match.find_by_schedule_id_and_user_id(fee.item_id, fee.debit_id)
      type_id = @match.type_id unless @match.nil?
      
      # set subscription to flag status
      fee.update_attribute(:season_player, flag)
      fee.update_attribute(:type_id, type_id)
        
      # unless flag is true then user does not has a subscription   
      # and if user has played match then set season_player to false to that it gets charged...
      unless flag
        fee.update_attribute(:season_player, !(fee.type_id == 1))
      end
    end    
  end

  def self.create_user_fees(schedule)    
    schedule.group.users.each do |user|

      @match = Match.find_by_schedule_id_and_user_id(schedule, user)
      type_id = 3
      type_id = @match.type_id unless @match.nil?
      season_player = user.is_subscriber_of?(schedule.group) 

      self.create_debit_credit_item_fee(user, schedule.group, schedule, season_player, type_id)
    end
  end

  def self.create_group_fees(schedule)
    self.create_debit_credit_item_fee(schedule.group, schedule.group.marker, schedule)
  end 

  def self.create_debit_credit_item_fee(debit, credit, item, season_player=false, type_id=1)
    fee_per_game = item.fee_per_game
    fee_per_game = item.fee_per_pista if credit.class.to_s == "Marker"
    
    if self.debit_credit_item_exists?(debit, credit, item)       
      self.create!(:concept => item.concept, :description => item.description, :debit_amount => fee_per_game,
                    :debit_id => debit.id, :credit_id => credit.id, :item_id => item.id, 
                    :debit_type => debit.class.to_s, :credit_type => credit.class.to_s, :item_type => item.class.to_s,
                    :season_player => season_player, :type_id => type_id)    
    
    else
      @fees = Fee.find(:all, 
        :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ? and item_id = ? and item_type = ?",
        debit.id, debit.class.to_s, credit.id, credit.class.to_s, item.id, item.class.to_s])
      
      @fees.each do |fee|
        fee.debit_amount = fee_per_game
        fee.save!
      end
      
    end
  end

private
	
  # return true if the schedule user group conbination is nil
  def self.debit_credit_item_exists?(debit, credit, item)                          
    find(:first, :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ? and 
                                item_id = ? and item_type = ? and archive = false", 
                                debit.id, debit.class.to_s, credit.id, credit.class.to_s, item.id, item.class.to_s]).nil?              
	end 

end