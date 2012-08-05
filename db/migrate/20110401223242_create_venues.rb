class CreateVenues < ActiveRecord::Migration
  def self.up        
    create_table :venues do |t|
      t.string          :name
      
      t.datetime        :starts_at
      t.datetime        :ends_at  
      
      t.string          :time_zone
      
      t.integer         :marker_id  
      
      t.boolean         :enable_comments,         :default => true      
      t.boolean         :public,                  :default => true
 
      t.string          :photo_file_name
      t.string          :photo_content_type
      t.integer         :photo_file_size
      t.datetime        :photo_updated_at
      
      t.text            :description
      
      t.boolean         :archive,                 :default => false
      t.timestamps
    end
    add_index   :venues,  :marker_id    
  end

  def self.down
  end
end
