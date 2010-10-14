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
  
  validates_presence_of         :debit_id
  validates_presence_of         :debit_type
  validates_presence_of         :credit_id
  validates_presence_of         :credit_type
  validates_presence_of         :item_id
  validates_presence_of         :item_type

  # variables to access
  attr_accessible :concept, :description, :payed, :debit_amount, :season_player
  attr_accessible :debit_id, :debit_type, :credit_id, :credit_type, :item_id, :item_type 
  attr_accessible :type_id, :manager_id
  
  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :concept, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "edit", "update", "destroy", "show"]


  # method section
  def self.sum_debit_amount_fee(the_fees)
    debit_fee = Fee.new
    debit_fee.debit_amount = 0.0
    the_fees.each {|the_fee| debit_fee.debit_amount += the_fee.debit_amount.to_f}
    return debit_fee        
  end

  def self.debits_credits_items_fees(debits, credits, items, the_fees)
    
    case items.first.class.to_s
    when "Group"
      fees = find(:all, :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
                                       fees.credit_id in (?) and fees.credit_type = ? and 
                                       fees.item_id in (?) and fees.item_type = ? and
                                       fees.archive = false", debits, debits.first.class.to_s, credits, credits.first.class.to_s, items, items.first.class.to_s]).each do |fee|
          the_fees << fee
      end
    when "Schedule"
      fees = find(:all, :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
                        :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
                                       fees.credit_id in (?) and fees.credit_type = ? and 
                                       fees.item_id in (?) and fees.item_type = ? and
                                       fees.archive = false and matches.type_id = 1", debits, debits.first.class.to_s, credits, credits.first.class.to_s, items, items.first.class.to_s]).each do |fee|
          the_fees << fee
      end
    end 
      
    return the_fees
  end
  
  def self.page_all_fees(the_fees, page=1)
    paginate(:all, :conditions => ["id in (?)", the_fees], :order => 'fees.id DESC', :page => page, :per_page => FEES_PER_PAGE)
  end

  def self.debit_item_amount(debits, credit)
    unless (debits.first.class.to_s == credit.class.to_s)
      @fee = find(:first, :select => "sum(debit_amount) as debit_amount", 
                :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and fees.credit_id in (?) 
                                 and fees.credit_type = ? and fees.archive = false", debits, debits.first.class.to_s, credit, credit.class.to_s])
    else
      if debits.first.class.to_s == 'User'
      @fee = find(:first, :select => "sum(debit_amount) as debit_amount", 
                  # :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
                  :conditions => ["fees.debit_id in (?) and fees.debit_type = ?  and 
                                  matches.type_id = 1 and fees.season_player = false and fees.archive = false", debits, debits.first.class.to_s])
      end
    end
    
    if @fee.nil? or @fee.blank? 
      @fee.debit_amount = 0.0
    end
    return @fee
  end
   
  # def self.debit_items_fees(debits, credits, page=1)
  #   unless (debits.first.class.to_s == credits.first.class.to_s)
  #     paginate(:all, :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #              :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
  #                               fees.credit_id in (?) and fees.credit_type = ? and 
  #                               fees.archive = false and matches.type_id = 1", 
  #                               debits, debits.first.class.to_s, credits, credits.first.class.to_s],
  #              :order => 'fees.created_at', 
  #              :page => page,
  #              :per_page => FEES_PER_PAGE)
  #   else
  #     if debits.first.class.to_s == 'User'
  #     paginate(:all, :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id", 
  #              :conditions => ["fees.debit_id in (?) and fees.debit_type = ?  and 
  #                               matches.type_id = 1 and fees.season_player = false and 
  #                               fees.archive = false and matches.type_id = 1", debits, debits.first.class.to_s],
  #              :order => 'fees.created_at', 
  #              :page => page,
  #              :per_page => FEES_PER_PAGE)
  #     end             
  #   end
  # end
  
  # def self.debit_items_amount(debits, credits)
  #   unless (debits.first.class.to_s == credits.first.class.to_s)
  #     @fee = find(:first, :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #                         :select => "sum(debit_amount) as debit_amount", 
  #                         :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
  #                                          fees.credit_id in (?) and fees.credit_type = ? and 
  #                                          fees.archive = false and matches.type_id = 1", debits, debits.first.class.to_s, credits, credits.first.class.to_s])
  #   else
  #     if debits.first.class.to_s == 'User'
  #     @fee = find(:first, :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #                         :select => "sum(debit_amount) as debit_amount", 
  #                         :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
  #                                          fees.archive = false and matches.type_id = 1", debits, debits.first.class.to_s])
  #     end
  #   end
  #   
  #   if @fee.nil? or @fee.blank? 
  #     @fee.debit_amount = 0.0
  #   end
  #   return @fee
  # end  
  
  
  # def self.debit_item_fees(debits, credit, page=1)
  #   unless (debits.first.class.to_s == credit.class.to_s)
  #     paginate(:all,     
  #              :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
  #                               fees.credit_id in (?) and fees.credit_type = ? and fees.archive = false", 
  #                               debits, debits.first.class.to_s, credit, credit.class.to_s],
  #              :order => 'fees.created_at', 
  #              :page => page,
  #              :per_page => FEES_PER_PAGE)
  #   else
  #     if debits.first.class.to_s == 'User'
  #     paginate(:all, 
  #     # :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #              :conditions => ["fees.debit_id in (?) and fees.debit_type = ?  and 
  #                               matches.type_id = 1 and fees.season_player = false and fees.archive = false", debits, debits.first.class.to_s],
  #              :order => 'fees.created_at', 
  #              :page => page,
  #              :per_page => FEES_PER_PAGE)
  #     end             
  #   end
  # end
        
  # def self.debit_fees(debits, credits, page=1)
  #   paginate(:all,
  #            :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #            :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and 
  #                             fees.credit_id in (?) and fees.credit_type = ? and matches.type_id = 1 and fees.season_player = false and fees.archive = false", 
  #                             debits, 'User', credits, 'Group'],
  #            :order => 'fees.item_type, fees.item_id', 
  #            :page => page,
  #            :per_page => FEES_PER_PAGE)
  # end
  
  # def self.debit_amount(debits, credits)
  #   @fee = find(:first, :select => "sum(debit_amount) as debit_amount", 
  #   :joins => "LEFT JOIN matches on matches.user_id = fees.debit_id and matches.schedule_id = fees.item_id",
  #   :conditions => ["fees.debit_id in (?) and fees.debit_type = ? and fees.credit_id in (?) and fees.credit_type = ? and 
  #     matches.type_id = 1 and fees.season_player = false and fees.archive = false", 
  #     debits, 'User', credits, 'Group'])
  # 
  #     if @fee.nil? or @fee.blank? 
  #       @fee.debit_amount = 0.0
  #     end
  #     return @fee
  #   end
  
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

  def self.create_user_challenge_fees(challenge)
    challenge["concept"] = challenge.name   
    challenge.users.each do |user|
      self.create_debit_credit_item_fee(user, challenge, challenge)
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
  
  # archive or unarchive a fee
  def self.set_archive_flag(debit, credit, item, flag)
    @fees = Fee.find(:all, :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ? and item_id = ? and item_type = ?", 
                                  debit.id, debit.class.to_s, credit.id, credit.class.to_s, item.id, item.class.to_s])
    @fees.each {|fee| fee.update_attribute(:archive, flag)}    
  end
  
protected
  def validate
    errors.add(:debit_amount, I18n.t(:should_be_positive)) unless debit_amount.nil? || debit_amount >= 0.0
  end

private
  # return true if the schedule user group conbination is nil
  def self.debit_credit_item_exists?(debit, credit, item)                          
    find(:first, :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ? and 
                                item_id = ? and item_type = ? and archive = false", 
                                debit.id, debit.class.to_s, credit.id, credit.class.to_s, item.id, item.class.to_s]).nil?              
	end 

end