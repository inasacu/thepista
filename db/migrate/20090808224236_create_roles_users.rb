class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false, :force => true  do |t|
      t.integer     :user_id
      t.integer     :role_id
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
