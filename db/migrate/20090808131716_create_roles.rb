class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string    :name,                :limit => 40
      t.string    :authorizable_type,   :limit => 40
      t.integer   :authorizable_id
      t.datetime  :deleted_at
      t.timestamps
    end
    
    # insert into roles (id, name) values (7440, 'maximo')
    # insert into roles_users (user_id, role_id) values(2901, 7440)
    
    
    # Role.create(:id => 72440, :name => 'maximo')
    # RolesUsers.create(:user_id => 2304, :role_id => 72440)
    # RolesUsers.create(:user_id => 2901, :role_id => 72440)
    
#    update roles set id = 72440 where id = 1
#    update users set id = 2901 where email = 'support@haypista.com'
#    update users set id = 2304 where email = 'inasacu@gmail.com'

  end

  def self.down
    drop_table :roles
  end
end
