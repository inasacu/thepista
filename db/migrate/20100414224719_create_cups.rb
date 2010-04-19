class CreateCups < ActiveRecord::Migration
  def self.up

    create_table :cups do |t|

      t.string      :name
      
      t.datetime    :starts_at
      t.datetime    :ends_at
      t.datetime    :deadline_at
      
      t.string      :time_zone
      
      t.integer     :sport_id 
                 
      t.boolean     :group_stage,           :default => true
      t.boolean     :group_stage_single,    :default => true
      t.boolean     :second_stage_single,   :default => true
      t.boolean     :final_stage_single,    :default => true
      
      t.integer     :points_for_win,        :default => 3
      t.integer     :points_for_draw,       :default => 1
      t.integer     :points_for_lose,       :default => 0
      t.text        :description
      
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
    drop_table :cups
  end
end

