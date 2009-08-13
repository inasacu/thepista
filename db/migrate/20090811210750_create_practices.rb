class CreatePractices < ActiveRecord::Migration
  def self.up
    create_table :practices do |t|
      t.string    :concept

      t.datetime  :starts_at
      t.datetime  :ends_at
      t.boolean   :reminder
      
      t.integer   :practice_attendees_count,    :default => 0
      t.integer   :group_id
      t.integer   :user_id
      t.integer   :sport_id
      t.integer   :marker_id

      t.string    :time_zone,       :default => 'UTC'
      
      t.text      :description

      t.integer   :player_limit
      
      t.boolean   :played,                      :default => false
      t.boolean   :privacy,                     :default => true
      t.boolean   :archive,                     :default => false
      t.datetime  :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :practices
  end
end
