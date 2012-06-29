class RemoveForumCommentsTables < ActiveRecord::Migration
	def up
		drop_table		:comments
		drop_table		:rates
		drop_table 		:blogs
		drop_table		:slugs 
		drop_table 		:classifieds
		drop_table		:posts
		drop_table		:tags
		drop_table 		:taggings
		drop_table 		:undo_items
		drop_table 		:pages
	end

	def down
	end
end
