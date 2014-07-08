class AddUserYoUsername < ActiveRecord::Migration
  def up
    add_column  :users, :yo_username, :string
  end

  def down
  end
end
