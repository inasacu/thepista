class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :id => false do |t|      
      t.integer     :group_id
      t.integer     :user_id      
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
