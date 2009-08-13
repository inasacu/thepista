class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.string      :concept,       :limit => 50      
      t.text        :description
      
      t.float       :actual_fee,    :default => 0.0      
      t.string      :payed,         :default => 'No'
      
      t.string      :table_type,    :limit => 40
      t.integer     :table_id
      
      t.integer     :schedule_id
      t.integer     :group_id
      t.integer     :user_id      
      t.integer     :match_id
      
      t.boolean     :archive,             :default => false
      t.datetime    :deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
