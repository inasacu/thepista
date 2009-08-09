class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.string        :name,            :default => '',     :limit => 150
      
      t.decimal       :latitude,        :precision => 15,   :scale => 10
      t.decimal       :longitude,       :precision => 15,   :scale => 10
      
      t.string        :direction
      t.string        :image_url
      t.string        :url
      
      t.string        :contact,         :limit => 150     
      t.string        :email
      t.string        :phone,           :limit => 40
      t.string        :address,         :default => ''
      t.string        :city,            :default => ''
      t.string        :region,          :default => '', :limit => 40
      t.string        :zip,             :default => '', :limit => 40
      t.string        :surface          
      t.string        :facility         
      
      t.datetime      :starts_at
      t.datetime      :ends_at
      
      t.string        :time_zone,           :default => 'UTC'
      
      t.boolean       :public,              :default => true
      t.boolean       :activation,          :default => false
      
      t.text          :description
      
      t.string        :icon,                :limit => 100,      :default => "" 
      t.string        :shadow,              :limit => 100,      :default => ""  
      t.boolean       :archive,             :default => false
      t.datetime      :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :markers
  end
end
