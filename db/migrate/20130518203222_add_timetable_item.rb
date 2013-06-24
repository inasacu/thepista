class AddTimetableItem < ActiveRecord::Migration
  def up
	
			add_column		:timetables,			:item_id,					:integer
			add_column		:timetables,			:item_type,				:string
			add_column		:schedules,				:block_token,			:string
			
  end

  def down
  end
end
