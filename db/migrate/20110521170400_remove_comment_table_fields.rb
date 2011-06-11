class RemoveCommentTableFields < ActiveRecord::Migration
  def self.up
    remove_column     :comments,      :entry_id
    remove_column     :comments,      :group_id
    
    add_column        :comments,      :parent_id,   :integer
    add_column        :comments,      :lft,         :integer
    add_column        :comments,      :rgt,         :integer
  
    # add_index "comments", "user_id"
    # add_index "comments", "commentable_id"
  end

  def self.down
    add_column        :comments,      :entry_id,    :integer
    add_column        :comments,      :group_id,    :integer
    
    remove_column     :comments,      :parent_id
    remove_column     :comments,      :lft
    remove_column     :comments,      :rgt
  end
end
