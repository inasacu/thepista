class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string      :name
      t.integer     :user_id
      t.integer     :group_id
      t.integer     :entries_count,   :null => false,   :default => 0
      t.text        :description
      t.timestamps
    end
      add_index   :blogs,     :user_id
      add_index   :blogs,     :group_id
  end

  def self.down
    drop_table :blogs
  end
end
