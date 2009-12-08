class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
        t.string      :name,                  :limit => 150    
        t.integer     :tournament_id
        
        t.integer     :jornada,               :default => 1
          
        t.text        :description 
        t.text        :conditions

        t.boolean     :archive,               :default => false
        t.datetime    :deleted_at
        t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
