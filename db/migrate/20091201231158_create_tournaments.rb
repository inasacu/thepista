class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|      
      t.string      :name,                  :limit => 150      
      t.text        :description   
               
      t.datetime    :starts_at      
      t.datetime    :ends_at            
      t.datetime    :signup_at      
      t.datetime    :deadline_at    
                      
      t.string      :season,                :limit => 50
      t.string      :time_zone            
      t.float       :price,                 :default => 0.0  
                    
      t.integer     :sport_id,              :default => 0      
      t.integer     :marker_id,             :default => 0   

      t.integer     :points_for_win,        :default => 1,  :null => false      
      t.integer     :points_for_draw,       :default => 0,  :null => false      
      t.integer     :points_for_lose,       :default => 0,  :null => false      

      t.string      :contact,               :limit => 150      
      t.string      :email,                 :limit => 150     
      t.string      :mobile,                :limit => 40           
         
      t.text        :conditions     
                     
      t.string      :photo_file_name          
      t.string      :photo_content_type          
      t.integer     :photo_file_size          
      t.datetime    :photo_updated_at
                        
      t.datetime    :deleted_at      
      t.boolean     :archive,           :default => false     

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
