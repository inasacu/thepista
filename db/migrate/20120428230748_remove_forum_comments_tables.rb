class RemoveForumCommentsTables < ActiveRecord::Migration
  def up
		# drop_table 		:forums
		# drop_table		:comments
		# drop_table		:rates
		# drop_table 		:blogs
		# drop_table		:slugs  -- donot remove until you run =>  rake the_update_slugs
  end

  def down
  end
end
