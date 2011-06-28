class CreatePrePurchases < ActiveRecord::Migration
  def self.up
    create_table :pre_purchases do |t|

      t.integer   :installation_id
      t.string    :block_token
      t.integer   :item_id
      t.string    :item_type

      t.timestamps
    end
    add_index     :pre_purchases,    [:installation_id,    :block_token]
    add_index     :pre_purchases,    [:item_id,    :item_type]
  end

  def self.down
    drop_table :pre_purchases
  end
end
