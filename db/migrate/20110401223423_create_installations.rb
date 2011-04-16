class CreateInstallations < ActiveRecord::Migration
  def self.up
    # drop_table :installations
    
    create_table :installations do |t|
      t.string          :name

      t.integer         :venue_id
      t.integer         :sport_id
      t.integer         :marker_id

      t.datetime        :starts_at
      t.datetime        :ends_at

      t.float           :fee_per_game,        :default => 0.0
      t.float           :fee_per_lighting,    :default => 0.0

      t.boolean         :public,              :default => true
      t.boolean         :lighting,            :default => true
      t.boolean         :outdoor,             :default => true
 
      t.string          :photo_file_name
      t.string          :photo_content_type
      t.integer         :photo_file_size
      t.datetime        :photo_updated_at

      t.text            :description
      t.text            :conditions
      t.boolean         :archive,             :default => false

      t.timestamps
    end
    add_index     :installations,   :venue_id
    add_index     :installations,   :sport_id
    add_index     :installations,   :marker_id
    
    # rake db:migrate VERSION=20110401223242
    # rake db:migrate
  end

  def self.down
    drop_table :installations
  end
end
