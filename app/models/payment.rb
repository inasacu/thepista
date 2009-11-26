class Payment < ActiveRecord::Base

  has_friendly_id :concept, :use_slug => true,:reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]

  belongs_to    :debit,        :polymorphic => true
  belongs_to    :credit,       :polymorphic => true
  belongs_to    :item,         :polymorphic => true 
  belongs_to    :fee

  # validations 
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :debit_amount,  :credit_amount
  validates_numericality_of     :debit_amount,  :credit_amount 

  # variables to access
  attr_accessible :concept, :description, :debit_amount, :credit_amount

  def self.current_payments(user, page = 1)
     self.paginate(:all, 
        :conditions => ["debit_amount > 0 and debit_type = 'User' and debit_id = ?", user.id],
        :order => 'created_at', :page => page, :per_page => PAYMENTS_PER_PAGE)
  end

  def self.debit_payment(debit, archive=false)
    @payment = find(:first, 
         :select => "sum(debit_amount) as actual_payment", 
         :conditions => ["debit_id = ? and debit_type = ? and archive = ?", debit.id, debit.class.to_s, archive])
         
    if @payment.nil? or @payment.blank? 
      @payment.actual_payment = 0.0
    end
    return @payment         
  end

  def self.credit_payment(debit, archive=false)
    @payment = find(:first, 
         :select => "sum(credit_amount) as actual_payment", 
         :conditions => ["credit_id = ? and credit_type = ? and archive = ?", debit.id, debit.class.to_s, archive])

    if @payment.nil? or @payment.blank? 
      @payment.actual_payment = 0.0
    end
    return @payment         
  end
  

    
  protected
    def validate
      errors.add(:debit_amount, I18n.t(:should_be_positive)) unless debit_amount.nil? || debit_amount >= 0.0
      errors.add(:credit_amount, I18n.t(:should_be_positive)) unless credit_amount.nil? || credit_amount >= 0.0
    end
end