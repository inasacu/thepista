class CreateClashes < ActiveRecord::Migration
  def self.up
    create_table :clashes do |t|
      t.string    :name,              :default => "Match Day"        
      t.integer   :meet_id          
      t.integer   :user_id        
      t.integer   :user_score,        :default => 0
      t.boolean   :played,            :default => false        
      t.integer   :one_x_two
      t.integer   :user_x_two
      t.integer   :type_id,           :default => 1 
      t.integer   :position_id,       :default => 18
      t.integer   :technical,         :default => 3
      t.integer   :physical,          :default => 3   
      t.datetime  :status_at,         :default => Time.now  
      t.text      :description 
      t.datetime  :deleted_at     
      t.boolean   :archive,           :default => false        
      
      t.timestamps
    end
  end

  def self.down
    drop_table :clashes
  end
end
