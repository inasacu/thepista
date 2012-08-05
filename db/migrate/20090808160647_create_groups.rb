class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      
      t.string      :name
      t.string      :second_team

      t.datetime    :gameday_at
      
      t.integer     :technical
      t.integer     :physical
      
      t.boolean     :private_profile,     :default => false
      t.string      :default_available,   :default => false
      
      t.float       :points_for_win,      :default => 1
      t.float       :points_for_draw,     :default => 0
      t.float       :points_for_lose,     :default => 0
      
      t.string      :time_zone,           :default => 'UTC'

      t.integer     :sport_id
      t.integer     :marker_id
            
      t.text        :description
      t.text        :conditions
      
      t.integer     :player_limit,        :default => 99
                  
      t.string      :blog_title
      t.integer     :entries_count,       :null => false,     :default => 0
      t.integer     :comments_count,      :null => false,     :default => 0
      t.boolean     :enable_comments,     :default => true

      t.string      :photo_file_name
      t.string      :photo_content_type
      t.integer     :photo_file_size
      t.datetime    :photo_updated_at
              
      t.boolean     :archive,               :default => false
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
