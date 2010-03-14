class AddGroupUserLooking < ActiveRecord::Migration
  def self.up
    add_column      :schedules,     :reminder_at,               :datetime
    add_column      :groups,        :looking,          :boolean,         :default => true
    add_column      :users,         :looking,         :boolean,         :default => true
  end

  def self.down
    remove_column     :schedules,     :reminder_at
    remove_column     :groups,        :looking
    remove_column     :users,         :looking
  end
end
