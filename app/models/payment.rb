class Payment < ActiveRecord::Base
  
  belongs_to    :debit,        :polymorphic => true
  belongs_to    :credit,       :polymorphic => true  
  belongs_to    :fee
  
  # validations 
  validates_presence_of       :concept, :debit_amount, :credit_amount
  validates_numericality_of   :debit_amount, :credit_amount 

  # variables to access
  attr_accessible :concept, :debit_amount, :credit_amount, :description, :table_type, :table_id, :type_id 

  
  def self.actual_payment(debit, archive=false)
    @payment = find(:first, 
         :select => "sum(debit_amount) - sum(credit_amount) as actual_payment", 
         :conditions => ["debit_id = ? and debit_type = ? and archive = ?", debit.id, debit.class.to_s, archive])
         
    if @payment.nil? or @payment.blank? 
      @payment.actual_payment = 0.0
    end
    return @payment         
  end
  
#   def self.get_credit_payments(debit, archive=false, page=1)
#     conditions = [%((debit_id = :debit and debit_type = :debit_type and debit_amount > 0) or (credit_id = :debit and credit_type = :debit_type and credit_amount > 0) and archive = :archive),
#                   {:debit => debit, :debit_type => debit.class.to_s, :archive => archive}]
#     
#     paginate(:all, :conditions => conditions, :order => 'created_at DESC, id', :page => page)
#   end
#   
# protected
#   def validate
#     errors.add(:debit_amount, :should_be_positive.l) unless debit_amount.nil? || debit_amount >= 0.0
#     errors.add(:credit_amount, :should_be_positive.l) unless credit_amount.nil? || credit_amount >= 0.0
#   end
# end
end