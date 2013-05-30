class AddTimetableItem < ActiveRecord::Migration
  def up
	
			add_column		:timetables,			:item_id,					:integer
			add_column		:timetables,			:item_type,				:string
			
  end

  def down
  end
end
