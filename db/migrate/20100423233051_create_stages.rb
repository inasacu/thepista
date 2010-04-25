class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|

      t.string    :name      
      t.integer   :cup_id 
      
      t.integer   :home_ranking
      t.string    :home_stage_name
      
      t.integer   :away_ranking
      t.string    :away_stage_name
      
      t.datetime  :deleted_at    
      t.boolean   :archive,            :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
