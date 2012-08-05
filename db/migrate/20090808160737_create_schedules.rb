class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string        :concept
      t.string        :season
      t.integer       :jornada

      t.datetime      :starts_at
      t.datetime      :ends_at
      t.datetime      :reminder_at
      
      t.datetime      :subscription_at
      t.datetime      :non_subscription_at

      t.float         :fee_per_game,        :default => 0.0
      t.float         :fee_per_pista,       :default => 0.0
      
      t.integer       :remind_before,       :default => 2
      t.integer       :repeat_every,        :default => 7

      t.string        :time_zone,           :default => 'UTC'

      t.integer       :group_id
      t.integer       :sport_id
      t.integer       :marker_id

      t.integer       :player_limit,        :default => 99
      
      t.boolean       :played,              :default => false
      t.boolean       :public,              :default => true
      
      t.text          :description
      t.boolean       :archive,             :default => false
      t.datetime      :deleted_at
      t.timestamps
    end
      add_index     :schedules,   :group_id    
  end

  def self.down
  end
end
