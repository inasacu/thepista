class CreateScorecards < ActiveRecord::Migration
  def self.up
    create_table :scorecards do |t|
      t.integer     :group_id
      t.integer     :user_id   
        
      t.integer     :wins,                :default => 0
      t.integer     :draws,               :default => 0
      t.integer     :losses,              :default => 0
      t.integer     :points,              :default => 0 
      t.integer     :ranking,             :default => 0
      t.integer     :played,              :default => 0
      t.integer     :assigned,            :default => 0

      t.integer     :goals_for,           :default => 0
      t.integer     :goals_against,       :default => 0
      t.integer     :goals_scored,        :default => 0
      
      t.integer     :previous_points,     :default => 0
      t.integer     :previous_ranking,    :default => 0
      t.integer     :previous_played,     :default => 0
      t.integer     :payed,               :default => 0   
      
      t.boolean     :archive,             :default => false
      t.datetime    :deleted_at
      t.timestamps
    end
      add_index   :scorecards,    :group_id
      add_index   :scorecards,    :user_id
  end

  def self.down
  end
end
