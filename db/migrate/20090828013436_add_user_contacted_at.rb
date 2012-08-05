class AddUserContactedAt < ActiveRecord::Migration
  def self.up
    add_column  :users,   :last_contacted_at,           :datetime
  end

  def self.down
  end
end
