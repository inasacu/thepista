class AddScheduleSentReminderResult < ActiveRecord::Migration
  def self.up
      add_column      :schedules,       :send_reminder_at,      :datetime
      add_column      :schedules,       :send_result_at,        :datetime
  end

  def self.down
  end
end
