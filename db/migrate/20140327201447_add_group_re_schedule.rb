class AddGroupReSchedule < ActiveRecord::Migration
  def up
    add_column  :groups,  :automatic_schedule,          :boolean,       :default => false
    add_column  :groups,  :automatic_schedule_limit,    :integer,       :default => 0
    add_column  :cups,    :public,                      :boolean,       :default => true
    add_column  :cups,    :player_limit,                :integer,       :default => 50
    add_column  :cups,    :city_id,                     :integer,       :default => 1
  end

  def down
  end
end
