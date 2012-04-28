class RemoveSchedulesUnusedFields < ActiveRecord::Migration
  def up
	
		remove_column			:schedules,				:season_ends_at
		remove_column			:schedules,				:description
	
  end

  def down
  end
end
