class RemoveCommentTableFields < ActiveRecord::Migration
  def self.up
    remove_column     :comments,      :entry_id
    remove_column     :comments,      :group_id
  end

  def self.down
    add_column        :comments,      :entry_id,    :integer
    add_column        :comments,      :group_id,    :integer
  end
end
