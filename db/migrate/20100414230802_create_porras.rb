class CreatePorras < ActiveRecord::Migration
  def self.up
    create_table :porras do |t|

      t.string      :name   
      t.integer     :cup_id
	  
      t.datetime    :starts_at
      t.datetime    :ends_at
      t.datetime    :reminder_at
      
      t.string      :time_zone
            
      t.text        :description
      t.text        :conditions
      
      t.integer     :player_limit,        :default => 99
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :porras
  end
end
