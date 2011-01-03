class Payment < ActiveRecord::Base
  
  belongs_to    :manager,        :class_name => 'User',        :foreign_key => 'manager_id'
  belongs_to    :debit,          :polymorphic => true
  belongs_to    :credit,         :polymorphic => true
  belongs_to    :item,           :polymorphic => true
  belongs_to    :fee

  # validations 
  validates_presence_of         :concept
  validates_length_of           :concept,                         :within => NAME_RANGE_LENGTH

  validates_presence_of         :description
  validates_length_of           :description,                     :within => DESCRIPTION_RANGE_LENGTH

  validates_presence_of         :debit_amount,  :credit_amount
  validates_numericality_of     :debit_amount,  :credit_amount 
  
  validates_presence_of         :debit_id
  validates_presence_of         :debit_type
  validates_presence_of         :credit_id
  validates_presence_of         :credit_type
  validates_presence_of         :item_id
  validates_presence_of         :item_type

  # variables to access
  attr_accessible :concept, :description, :debit_amount, :credit_amount, :debit_id, :debit_type
  attr_accessible :credit_id, :credit_type, :item_id, :item_type, :manager_id, :fee_id

  # NOTE:  MUST BE DECLARED AFTER attr_accessible otherwise you get a 'RuntimeError: Declare either attr_protected or attr_accessible' 
  has_friendly_id :concept, :use_slug => true, :approximate_ascii => true, 
                   :reserved_words => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]
  
  # method section
  def self.debit_user_item_schedule(debits, credits, the_payments)
    payments = find(:all, :joins => "JOIN groups on groups.id = payments.credit_id",
               :conditions => ["payments.debit_id in (?) and payments.debit_type = 'User' and 
                                payments.credit_id in (?) and payments.credit_type = 'Group' and 
                                payments.debit_amount > 0 and payments.archive = false", debits, credits])
    payments.each {|payment| the_payments << payment}
    return the_payments
  end

  def self.sum_debit_payment(the_payments)
    debit_payment = Payment.new
    debit_payment.debit_amount = 0.0
    the_payments.each {|the_payment| debit_payment.debit_amount += the_payment.debit_amount.to_f}
    return debit_payment        
  end  
  
  def self.sum_debit_amount_payment(the_payments)
    debit_payment = Payment.new
    credit_payment = Payment.new
    debit_payment.debit_amount = 0.0
    credit_payment.debit_amount = 0.0
    
    the_payments.each {|the_payment| debit_payment.debit_amount += the_payment.debit_amount.to_f}
    return debit_payment, credit_payment       
  end

  def self.debits_credits_items_payments(debits, credits, items, the_payments)
    fees = find(:all, :conditions => ["payments.debit_id in (?) and payments.debit_type = ? and 
                                       payments.credit_id in (?) and payments.credit_type = ? and 
                                       payments.item_id in (?) and payments.item_type = ? and
                                       payments.archive = false and payments.debit_amount > 0", debits, debits.first.class.to_s, credits, credits.first.class.to_s, items, items.first.class.to_s]).each do |payment|
      the_payments << payment
    end
    return the_payments
  end

  def self.page_all_payments(the_payments, page=1)
    paginate(:all, :conditions => ["id in (?)", the_payments], :order => 'payments.id DESC', :page => page, :per_page => FEES_PER_PAGE)
  end
  
  def self.debit_item_amount(debits, item)    
    unless (debits.first.class.to_s == item.class.to_s)
      @payment = find(:first, :select => "sum(debit_amount) as debit_amount", 
      :conditions => ["debit_id in (?) and debit_type = ? and 
        item_id = ? and item_type = ? and 
        archive = false and debit_amount > 0", debits, debits.first.class.to_s, item, item.class.to_s])
      else
          @payment = find(:first, :select => "sum(debit_amount) as debit_amount", 
          :conditions => ["debit_id in (?) and debit_type = ? and 
            archive = false and debit_amount > 0", debits, debits.first.class.to_s])
      end
                      
    if @payment.nil? or @payment.blank? 
      @payment.debit_amount = 0.0
    end
    return @payment         
  end

  def self.credit_item_amount(credits, item)
    unless (credits.first.class.to_s == item.class.to_s)
      @payment = find(:first, :select => "sum(credit_amount) as credit_amount", 
      :conditions => ["credit_id in (?) and credit_type = ? and 
        item_id = ? and item_type = ? and
        archive = false and credit_amount > 0", credits, credits.first.class.to_s, item, item.class.to_s])
      else
          @payment = find(:first, :select => "sum(credit_amount) as credit_amount", 
          :conditions => ["credit_id in (?) and credit_type = ? and 
            archive = false and credit_amount > 0", credits, credits.first.class.to_s])
        end
                         
    if @payment.nil? or @payment.blank? 
      @payment.credit_amount = 0.0
    end
    return @payment         
  end

  def self.credit_item_payments(debits, credit, item, page=1)
    unless (debits.first.class.to_s == credit.class.to_s)
      paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and 
                                      credit_id in (?) and credit_type = ? and 
                                      item_id = ? and item_type = ? and 
                                      archive = false and debit_amount > 0", 
        debits, debits.first.class.to_s, 
        credit, credit.class.to_s, 
        item, item.class.to_s],
        :order => 'id', :page => page, :per_page => FEES_PER_PAGE)
    else
          paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and archive = false and debit_amount > 0", debits, debits.first.class.to_s],
            :order => 'id', :page => page, :per_page => FEES_PER_PAGE)
    end
  end
  
  def self.payments_for_fee(fee, page=1)
    paginate(:all, :conditions => ["fee_id = ? and debit_amount > 0 and archive = false", fee], :order => 'created_at', :page => page,  :per_page => FEES_PER_PAGE)
  end
    
  def self.credit_payments(debits, credits, page=1)
    unless (debits.first.class.to_s == credits.first.class.to_s)
      paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and 
                                    credit_id in (?) and credit_type = ? and 
                                    archive = false and debit_amount > 0", debits, debits.first.class.to_s, credits, credits.first.class.to_s],
             :order => 'id DESC', :page => page,  :per_page => FEES_PER_PAGE)
    else
     paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and archive = false and debit_amount > 0", debits, debits.first.class.to_s],
                    :order => 'id DESC', :page => page,  :per_page => FEES_PER_PAGE)
    end
  end

  def self.sum_debit_item_amount(debits, credits)
    @payment = find(:first, :select => "sum(debit_amount) as debit_amount", 
                            :conditions => ["debit_id in (?) and debit_type = ? and 
                                             credit_id in (?) and credit_type = ? and 
                                             archive = false and debit_amount > 0", debits, debits.first.class.to_s, credits, credits.first.class.to_s])

    if @payment.nil? or @payment.blank? 
      @payment.debit_amount = 0.0
    end
    return @payment         
  end


 def self.sum_credit_item_amount(debits, credits)
   @payment = find(:first, :select => "sum(credit_amount) as credit_amount", 
                           :conditions => ["debit_id in (?) and debit_type = ? and 
                                            credit_id in (?) and credit_type = ? and 
                                            archive = false and debit_amount > 0", debits, debits.first.class.to_s, credits, credits.first.class.to_s])

   if @payment.nil? or @payment.blank? 
     @payment.debit_amount = 0.0
   end
   return @payment         
  end
    
     
  def self.payment_debit_amount(debits, object)
    @payment = find(:first, :select => "sum(debit_amount) as debit_amount", 
                            :conditions => ["debit_id in (?) and debit_type = ? and archive = false and debit_amount > 0", debits, object])
         
    if @payment.nil? or @payment.blank? 
      @payment.debit_amount = 0.0
    end
    return @payment         
  end
  
  def self.payment_credit_amount(credits, object)
    @payment = find(:first, 
         :select => "sum(credit_amount) as credit_amount", 
         :conditions => ["credit_id in (?) and credit_type = ? and 
                         archive = false and credit_amount > 0", credits, object])

    if @payment.nil? or @payment.blank? 
      @payment.credit_amount = 0.0
    end
    return @payment         
  end
    
  protected
    def validate
      errors.add(:debit_amount, I18n.t(:should_be_positive)) unless debit_amount.nil? || debit_amount >= 0.0
      errors.add(:credit_amount, I18n.t(:should_be_positive)) unless credit_amount.nil? || credit_amount >= 0.0
    end
end