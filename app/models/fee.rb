class Fee < ActiveRecord::Base
  belongs_to     :user
  belongs_to     :manager,      :class_name => 'User',        :foreign_key => 'sender_id'
  
  belongs_to     :group
  belongs_to     :debit,        :polymorphic => true
  belongs_to     :credit,       :polymorphic => true
  has_many       :payments
  
  # validations
  validates_presence_of       :concept
  validates_numericality_of   :debit_amount    

  # variables to access
  attr_accessible :concept, :description, :payed, :table_type 
  attr_accessible :table_id, :schedule_id, :group_id, :user_id
  attr_accessible :debit_amount, :debit_id, :debit_type
  attr_accessible :credit_id, :credit_type, :manager_id
  
  def self.get_debit_fees(debit, season_payed=false, archive=false, page=1)
    paginate(:all, 
             :conditions => ["debit_id = ? and debit_type = ? and season_payed = ? and archive = ?", debit.id, debit.class.to_s, season_payed, archive],
             :order => 'created_at DESC', 
             :page => page,
             :per_page => FEES_PER_PAGE)
  end
  
  def self.debit_amount(debit, debit_name='User', season_payed=false, archive=false)
    @fee = find(:first, 
         :select => "sum(debit_amount) as debit_amount", 
         :conditions => ["debit_id = ? and debit_type = ? and season_payed = ? and archive = ?", debit.id, debit.class.to_s, season_payed, archive])
         
   if @fee.nil? or @fee.blank? 
     @fee.debit_amount = 0.0
   end
   return @fee
  end
   
#   def self.set_season_payed_match_flag(credit)
#     @fee = find(:first, :conditions => ["credit_id = ? and credit_type = ?", credit.id, credit.class.to_s])
#     if @fee
#       @fee.update_attribute(:season_payed, !(credit.type_id == 1))
#     end
#   end
#   
#   def self.set_season_payed_flag(debit, credit, credit_name, flag)
#     @fees = find(:all, 
#                  :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ?", debit, debit.class.to_s, credit, credit.class.to_s])    
#     @fees.each do |fee|
#       
#       # set subscription to flag status
#       fee.update_attribute(:season_payed, flag)
#         
#       # unless flag is true then user does not has a subscription   
#       # and if user has played match then set season_payed to false to that it gets charged...
#       
#       unless flag
#         fee.update_attribute(:season_payed, !(credit.type_id == 1))
#       end
#     end    
#   end
#     
#   def self.set_archive_flag(debit, credit, flag)
#     @fees = Fee.find(:all, 
#                  :conditions => ["debit_id = ? and debit_type = ? and credit_id = ? and credit_type = ?", debit, debit.class.to_s, credit, credit.class.to_s])   
#     @fees.each do |fee|
#       fee.update_attribute(:archive, flag)
#     end
#   end

  def self.create_user_fees(schedule)    
    schedule.group.users.each do |user|
      if self.schedule_user_exists?(schedule, user)
        self.create!(:concept => schedule.concept, :schedule_id => schedule.id, :user_id => user.id, 
                     :description => schedule.description, :group_id => schedule.group_id, 
                     :debit_amount => schedule.fee_per_game,
                     :debit_id => user.id, :debit_type => 'User',
                     :credit_id => schedule.group_id, :credit_type => 'Group')
      else
        self.find_by_schedule_id_and_user_id(schedule, user).update_attributes!(
                      :debit_amount => schedule.fee_per_game)
      end

    end
  end
  
  def self.create_group_fees(schedule)
    if self.schedule_group_exists?(schedule)
      self.create!(:concept => schedule.concept, :schedule_id => schedule.id, :group_id => schedule.group_id, 
                  :debit_amount => schedule.fee_per_game,
                  :debit_id => schedule.group_id, :debit_type => 'Group',
                  :credit_id => schedule.group.marker_id, :credit_type => 'Marker')
    else
      self.find(:first, 
                :conditions => ["schedule_id = ? and group_id = ? and user_id is null", schedule.id, schedule.group_id]).update_attributes(
                :debit_amount => schedule.fee_per_pista)
    end
  end
  
	def self.create_schedule_group_user_fee(schedule, user)
        self.create!(:concept => schedule.concept, :schedule_id => schedule.id, 
				:user_id => user.id, :group_id => schedule.group_id, :user_fee => true, 
				:debit_amount => schedule.fee_per_game) if self.schedule_group_user_exists(schedule, user)
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
    
# protected
#   def validate
#     errors.add(:debit_amount, :should_be_positive.l) unless debit_amount.nil? || debit_amount > 0.0
#   end
# end
end