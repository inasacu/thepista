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

  # friendly url and removes id
  has_friendly_id :concept, :use_slug => true,:reserved => ["new", "create", "index", "list", "signup", "edit", "update", "destroy", "show"]
  
  # method section
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
        :order => 'created_at', :page => page, :per_page => FEES_PER_PAGE)
    else
          paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and archive = false and debit_amount > 0", debits, debits.first.class.to_s],
            :order => 'created_at', :page => page, :per_page => FEES_PER_PAGE)
    end
  end
  
  def self.payments_for_fee(fee, page=1)
    paginate(:all, :conditions => ["fee_id = ? and debit_amount > 0 and archive = false", fee], :order => 'created_at', :page => page,  :per_page => FEES_PER_PAGE)
  end
    
  def self.credit_payments(debits, credits, page=1)
    paginate(:all, :conditions => ["debit_id in (?) and debit_type = ? and 
                                    credit_id in (?) and credit_type = ? and 
                                    archive = false and debit_amount > 0", debits, 'User', credits, 'Group'],
             :order => 'created_at', :page => page,  :per_page => FEES_PER_PAGE)
  end

  def self.debit_amount(debits, object)
    @payment = find(:first, 
         :select => "sum(debit_amount) as debit_amount", 
         :conditions => ["debit_id in (?) and debit_type = ? and 
                        archive = false and debit_amount > 0", debits, object])
         
    if @payment.nil? or @payment.blank? 
      @payment.debit_amount = 0.0
    end
    return @payment         
  end
  
  def self.credit_amount(credits, object)
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