class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
        t.string      :name
        t.integer     :schedule_id
        t.integer     :topics_count,   :null => false,   :default => 0
        t.text        :description
        t.timestamps
      end
        add_index   :forums,     :schedule_id
  end

  def self.down
    drop_table :forums
  end
end
