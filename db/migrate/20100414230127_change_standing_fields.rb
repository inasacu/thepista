class ChangeStandingFields < ActiveRecord::Migration
  def self.up

    drop_table :standings

    create_table :standings do |t| 
         
      t.integer :cup_id 
      t.integer :item_id
      t.string	:item_type		                    # for :squad_id, :user_id 
      
      t.integer :wins,          :default => 0
      t.integer :draws,         :default => 0
      t.integer :losses,        :default => 0
      
      t.integer :points,        :default => 0 
      t.integer :played,        :default => 0  
      t.integer :ranking,       :default => 0
      
      t.integer :goals_for,     :default => 0
      t.integer :goals_against, :default => 0

      t.datetime  :deleted_at    
      t.boolean   :archive,            :default => false

      t.timestamps
    end

  end

  def self.down
    drop_table :standings
  end
end
