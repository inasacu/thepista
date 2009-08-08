class CreateGroupsMarkers < ActiveRecord::Migration
  def self.up
    create_table :groups_markers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_markers
  end
end
