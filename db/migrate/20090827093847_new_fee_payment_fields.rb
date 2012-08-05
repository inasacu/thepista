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
  end

  def self.down
  end
end
