class RemoveUsersUnusedFields < ActiveRecord::Migration
  def up

		# remove_column			:users,						:description
		remove_column			:users,						:position
		remove_column 		:users,						:technical
		remove_column			:users,						:physical
		remove_column			:users,						:dorsal
		remove_column			:users,						:available
		remove_column			:users,						:rpxnow_id
		remove_column			:users,						:posts_count
		remove_column			:users,						:entries_count
		remove_column			:users,						:comments_count
		remove_column			:users,						:blog_title
		remove_column			:users,						:enable_comments
		remove_column			:users,						:blog_comment_notification
		remove_column			:users,						:forum_comment_notification
		remove_column			:users,						:looking
		remove_column			:users,						:openid_identifier
		
  end

  def down
  end
end
