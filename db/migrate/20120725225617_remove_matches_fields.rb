class RemoveMatchesFields < ActiveRecord::Migration
  def up
	
		add_column			:matches,				:change_id,							:integer
		# add_column			:groups,				:service_id,						:integer
		# add_column			:challenges,		:service_id,						:integer
		
		remove_column		:matches,			:rebounds_offense
  end

  def down
  end
end
