class RemoveGroupsUnusedFields < ActiveRecord::Migration
  def up
	
		remove_column			:groups,						:private_profile
		remove_column			:groups,						:blog_title
		remove_column			:groups,						:entries_count
		remove_column			:groups,						:comments_count
		remove_column			:groups,						:enable_comments
		remove_column			:groups,						:available
		remove_column			:groups,						:looking
		
  end

  def down
  end
end
