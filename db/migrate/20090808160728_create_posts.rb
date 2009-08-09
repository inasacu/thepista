class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer     :topic_id
      t.integer     :user_id
      t.text        :body
      t.timestamps
    end
    add_index   :posts,       :topic_id
  end

  def self.down
    drop_table :posts
  end
end
