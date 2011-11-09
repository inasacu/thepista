class RemoveUnneededFields < ActiveRecord::Migration
  def self.up
    remove_column     :groups,        :technical
    remove_column     :groups,        :physical

    remove_column     :blogs,         :user_id
    remove_column     :blogs,         :group_id

    drop_table :taggings
    drop_table :tags
    
  end

  def self.down
    add_column      :groups,        :technical,    :integer
    add_column      :groups,        :physical,    :integer

    add_column      :blogs,         :user_id,    :integer
    add_column      :blogs,         :group_id,    :integer
  end
end
