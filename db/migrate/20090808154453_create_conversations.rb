class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|

      t.timestamps
    end
  end

  def self.down
  end
end
