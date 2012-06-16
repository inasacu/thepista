class RemoveForumCommentsTables < ActiveRecord::Migration
  def up
		drop_table 		:forums
		drop_table		:comments
		drop_table		:rates
		drop_table 		:blogs
		drop_table		:slugs 
		drop_table 		:classifieds
  end

  def down
  end
end
