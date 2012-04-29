class RemoveForumCommentsTables < ActiveRecord::Migration
  def up
		drop_table 		:forums
		drop_table		:comments
  end

  def down
  end
end
