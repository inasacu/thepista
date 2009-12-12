class CreateMeets < ActiveRecord::Migration
  def self.up    
    create_table :meets do |t|
      t.string        :concept
      t.integer       :jornada

      t.datetime      :starts_at
      t.datetime      :ends_at
      t.datetime      :reminder_at
      
      t.integer       :marker_id
      t.integer       :round_id

      t.integer       :player_limit,        :default => 99
      
      t.boolean       :played,              :default => false
      t.boolean       :public,              :default => true

      t.text          :description

      t.boolean       :archive,             :default => false
      t.datetime      :deleted_at
      t.timestamps
    end
    add_index     :meets,   :round_id
  end

  def self.down
    drop_table :meets
  end
end
