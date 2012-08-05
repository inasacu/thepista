class FeeAdditionalFields < ActiveRecord::Migration
  def self.up
    add_column      :fees,        :item_type,       :string
    add_column      :fees,        :item_id,         :integer
    add_column      :fees,        :type_id,         :integer    
    add_column      :fees,        :season_player,   :boolean,   :default => false
    
    add_column      :payments,    :item_type,       :string
    add_column      :payments,    :item_id,         :integer
    
    remove_column   :payments,    :table_type
    remove_column   :payments,    :table_id
    remove_column   :payments,    :parent_id
    remove_column   :payments,    :type_id
    
    remove_column   :fees,        :season_payed

    add_index       :fees,            [:debit_id, :debit_type]
    add_index       :payments,        [:debit_id, :debit_type]
    add_index       :fees,            [:credit_id, :credit_type]
    add_index       :payments,        [:credit_id, :credit_type]
    add_index       :fees,            [:item_id, :item_type]
    add_index       :payments,        [:item_id, :item_type]
        
  end

  def self.down
  end
end
