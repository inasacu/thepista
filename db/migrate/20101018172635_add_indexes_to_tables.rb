class AddIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :taggings,    :taggable_id
  end

  def self.down
  end
end
