class CreateGroupsRoles < ActiveRecord::Migration
    def self.up
      create_table :groups_roles, :id => false, :force => true  do |t|
        t.integer     :group_id
        t.integer     :role_id
        t.datetime    :deleted_at
        t.timestamps
      end
    end

    def self.down
      drop_table :groups_roles
    end
  end

