class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string    :name,                :limit => 40
      t.string    :authorizable_type,   :limit => 40
      t.integer   :authorizable_id
      t.datetime  :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
