class AddGroupReSchedule < ActiveRecord::Migration
  def up
    add_column  :groups,  :automatic_schedule,          :boolean, :default => false
    add_column  :groups,  :automatic_schedule_limit,    :integer, :default => 0
  end

  def down
  end
end
