class NewFeePaymentFields < ActiveRecord::Migration
  def self.up
    add_column      :fees,        :debit_amount,  :float,   :default => 0.0
    add_column      :fees,        :debit_id,      :integer
    add_column      :fees,        :debit_type,    :string
    add_column      :fees,        :credit_id,     :integer
    add_column      :fees,        :credit_type,   :string
    add_column      :fees,        :manager_id,    :integer
    add_column      :fees,        :season_payed,  :boolean,   :default => false
    
    add_column      :payments,    :debit_id,      :integer
    add_column      :payments,    :debit_type,    :string
    add_column      :payments,    :credit_id,     :integer
    add_column      :payments,    :credit_type,   :string
    add_column      :payments,    :manager_id,    :integer
    add_column      :payments,    :fee_id,        :integer
    add_column      :payments,    :parent_id,     :integer
    
    remove_column   :fees,        :match_id
    
    # Fee.find(:all).each do |fee|
    #   fee.debit_amount = fee.actual_fee
    # 
    #   unless fee.user_id.nil?
    #     fee.debit_id = fee.user_id
    #     fee.debit_type = 'User'
    #   else
    #     fee.debit_id = fee.group_id
    #     fee.debit_type = 'Group'
    #   end
    # 
    #   fee.save!
    # end
    
    Type.find(1).update_attributes(:name => 'convocado')
    Type.find(2).update_attributes(:name => 'ultima_hora')
    Type.find(3).update_attributes(:name => 'ausente')
    Type.find(4).update_attributes(:name => 'no_jugado')
    
    
  end

  def self.down
    remove_column      :fees,        :debit_amount
    remove_column      :fees,        :debit_id
    remove_column      :fees,        :debit_type
    remove_column      :fees,        :credit_id
    remove_column      :fees,        :credit_type
    remove_column      :fees,        :manager_id
    remove_column      :fees,        :season_payed
    
    remove_column      :payments,    :debit_id
    remove_column      :payments,    :debit_type
    remove_column      :payments,    :credit_id
    remove_column      :payments,    :credit_type
    remove_column      :payments,    :manager_id
    remove_column      :payments,    :fee_id
    remove_column      :payments,    :parent_id
    
    add_column         :fees,         :match_id, :integer
  end
end
