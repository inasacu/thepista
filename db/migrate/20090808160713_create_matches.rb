class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.string      :name,              :default => "Match Day"
      
      t.integer     :schedule_id
      t.integer     :user_id      
      t.integer     :group_id
      t.integer     :invite_id
      
      t.integer     :group_score
      t.integer     :invite_score  
      t.integer     :goals_scored,      :default => 0      
      t.integer     :roster_position,   :default => 0
      
      t.boolean     :played,            :default => false      
      t.boolean     :available,         :default => true
      
      t.string      :one_x_two,         :limit => 1
      t.string      :user_x_two,        :limit => 1
      
      t.integer     :type_id
      
      t.datetime    :status_at,           :default => Time.now
      
      t.text        :description  
      
      t.boolean     :archive,             :default => false
      t.datetime    :deleted_at
      t.timestamps
    end
      add_index     :matches,   :schedule_id
      add_index     :matches,   :user_id
      add_index     :matches,   :group_id
      add_index     :matches,   :invite_id
  end

  def self.down
  end
end
