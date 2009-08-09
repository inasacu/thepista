class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
        t.integer     :blog_id
        t.integer     :user_id
        t.integer     :group_id
        t.string      :title
        t.text        :body
        t.integer     :comments_count,  :null => false,   :default => 0
        t.timestamps
      end
      add_index     :entries, :blog_id
  end

  def self.down
    drop_table :entries
  end
end
