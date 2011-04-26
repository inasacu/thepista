class RemoveActivities < ActiveRecord::Migration
  def self.up
    drop_table        :activities
  end

  def self.down
    create_table :activities, :force => true do |t|
      t.integer       :item_id
      t.string        :item_type
      t.integer       :user_id
      t.boolean       :public

      t.timestamps
    end

    add_index         :activities,      [:item_id, :item_type]
  end
end