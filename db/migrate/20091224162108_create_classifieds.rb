class CreateClassifieds < ActiveRecord::Migration
  def self.up
    drop_table :classifieds
    
    create_table :classifieds do |t|
      t.string        :concept

      t.datetime      :starts_at
      t.datetime      :ends_at
      t.datetime      :reminder_at
      
      t.integer       :group_id

      t.string        :item_type,           :limit => 40
      t.integer       :item_id

      t.string        :time_zone,           :default => 'UTC'

      t.text          :description
      t.boolean       :archive,             :default => false
      t.datetime      :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :classifieds
  end
end
