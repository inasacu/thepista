class AddUserEmailBackup < ActiveRecord::Migration
  def self.up
    add_column    :users,     :email_backup,      :string
    add_column    :users,     :sport,             :string
  end

  def self.down
  end
end
