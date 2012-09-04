class AddSchedulesSendCreatedAt < ActiveRecord::Migration
  def up
		add_column		:schedules,			:send_created_at,				:datetime
  end

  def down
  end
end
