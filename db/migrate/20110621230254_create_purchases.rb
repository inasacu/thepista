class CreatePurchases < ActiveRecord::Migration
  
  # drop_table      :purchases
  
  def self.up
    create_table :purchases do |t|
      
      t.string    :transaction_id
      
      t.integer   :item_id
      t.string    :item_type
      
      t.decimal   :amount
      t.string    :token
      
      t.integer   :installation_id
      t.string    :block_token
      
      t.string    :cvv2_code
      t.string    :avs_code
      
      t.datetime  :created_at

      t.timestamps
    end
    
    add_index     :purchases,    [:item_id,    :item_type]
  end

  def self.down
    drop_table :purchases
  end
end



# rake db:migrate VERSION=20110521170400
# rake db:migrate