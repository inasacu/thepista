class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_users
  end
end
