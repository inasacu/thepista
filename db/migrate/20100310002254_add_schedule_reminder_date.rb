class AddScheduleReminderDate < ActiveRecord::Migration
  def self.up
      add_column      :schedules,     :reminder_at,               :datetime
      add_column      :groups,        :looking_for_user,          :boolean,         :default => true
      add_column      :users,         :looking_for_group,         :boolean,         :default => true
  end

  def self.down
    remove_column     :schedules,     :reminder_at
    remove_column     :groups,        :looking_for_user
    remove_column     :users,         :looking_for_group
  end
end
