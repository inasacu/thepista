class CreateSports < ActiveRecord::Migration

  def self.up
    create_table :sports do |t|
      t.string      :name,                  :limit => 50
      t.text        :description
      t.string      :icon,                  :limit => 40
      
      t.float       :points_for_win,        :default => 3
      t.float       :points_for_lose,       :default => 0
      t.float       :points_for_draw,       :default => 1
      t.datetime    :deleted_at
      t.timestamps
    end
   
  end

  def self.down
  end
end

