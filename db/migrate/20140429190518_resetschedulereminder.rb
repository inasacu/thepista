class Resetschedulereminder < ActiveRecord::Migration
  def up
    change_column :schedules, :reminder, :boolean, :default => false 
    # update schedules set reminder = false
  end

  def down
  end
end
