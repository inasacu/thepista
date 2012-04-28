class RemoveMatchesUnusedFields < ActiveRecord::Migration
  def up
	
		remove_column			:matches,					:description		
		remove_column			:matches,					:technical
		remove_column			:matches,					:physical		
		remove_column			:matches,					:moral
		remove_column			:matches,					:rating_average_moral	
		remove_column			:matches,					:field_goal_attempt
		remove_column			:matches,					:field_goal_made
		remove_column			:matches,					:free_throw_attempt
		remove_column			:matches,					:free_throw_made
		remove_column			:matches,					:three_point_attempt
		remove_column			:matches,					:three_point_made
		remove_column			:matches,					:rebounds_defense
		remove_column			:matches,					:minutes_played
		remove_column			:matches,					:steals
		remove_column			:matches,					:blocks
		remove_column			:matches,					:turnovers
		remove_column			:matches,					:personal_fouls
		remove_column			:matches,					:started
		remove_column			:matches,					:position_id
		remove_column			:matches,					:name
		remove_column			:matches,					:slug
		remove_column			:matches,					:available
		remove_column			:matches,					:assists
		
  end

  def down
  end
end
