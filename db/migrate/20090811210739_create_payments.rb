class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string    :concept,               :limit => 150
      t.float     :debit_amount,          :default => 0.0 
      t.float     :credit_amount,         :default => 0.0      
      t.text      :description   
      
      t.string    :table_type,            :limit => 40
      t.integer   :table_id
      t.integer   :type_id      

      t.boolean   :archive,             :default => false
      t.datetime  :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
