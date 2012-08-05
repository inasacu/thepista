class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.string      :name   
      t.integer     :cup_id
	  
      t.datetime    :starts_at
      t.datetime    :ends_at
      t.datetime    :reminder_at
      
      t.float		    :fee_per_game,        :default => 0.0
      
      t.string      :time_zone
            
      t.text        :description
      t.text        :conditions
      
      t.integer     :player_limit,        :default => 99
              
      t.boolean     :archive,             :default => false
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
