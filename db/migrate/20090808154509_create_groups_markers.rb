class CreateGroupsMarkers < ActiveRecord::Migration
  def self.up
    create_table :groups_markers do |t|      
      t.integer     :group_id
      t.integer     :marker_id
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
  end
end
