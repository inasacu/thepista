class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      
      t.string    :concept

      t.datetime  :starts_at
      t.datetime  :ends_at
      t.datetime  :reminder_at      
      t.datetime  :deadline_at

      t.integer   :cup_id
      
      t.integer   :home_id       
      t.integer   :away_id 
      t.integer   :winner_id     
      t.integer   :next_game_id 

      t.integer   :home_ranking
      t.string    :home_stage_name
      t.integer   :away_ranking
      t.string    :away_stage_name
      
      t.integer   :home_score
      t.integer   :away_score
      
      t.integer   :jornada,                 :default => 1      
      t.integer   :round,                   :default => 1
      
      t.boolean   :played,                  :default => false
      
      t.string    :type_name,               :limit => 40

      t.integer   :points_for_single,       :default => 0
      t.integer   :points_for_double,       :default => 0

      t.timestamps
    end
  end

  def self.down
  end
end
