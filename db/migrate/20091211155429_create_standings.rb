class CreateStandings < ActiveRecord::Migration
  def self.up
    create_table :standings do |t|    
      t.integer   :round_id      
      t.integer   :user_id      
      t.integer   :played,             :default => 0             
      t.integer   :assigned,           :default => 0           
      t.integer   :wins,               :default => 0      
      t.integer   :draws,              :default => 0      
      t.integer   :losses,             :default => 0      
      t.integer   :points,             :default => 0      
      t.integer   :ranking,            :default => 0    
      t.datetime  :deleted_at    
      t.boolean   :archive,            :default => false  
                
      t.timestamps
    end
  end

  def self.down
  end
end
