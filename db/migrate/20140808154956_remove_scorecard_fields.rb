class RemoveScorecardFields < ActiveRecord::Migration
  def up
    remove_column :scorecards, :season_ends_at      
    remove_column :scorecards, :field_goal_attempt  
    remove_column :scorecards, :field_goal_made     
    remove_column :scorecards, :free_throw_attempt  
    remove_column :scorecards, :free_throw_made     
    remove_column :scorecards, :three_point_attempt 
    remove_column :scorecards, :three_point_made    
    remove_column :scorecards, :rebounds_defense    
    remove_column :scorecards, :rebounds_offense    
    remove_column :scorecards, :minutes_played      
    remove_column :scorecards, :assists             
    remove_column :scorecards, :steals              
    remove_column :scorecards, :blocks              
    remove_column :scorecards, :turnovers           
    remove_column :scorecards, :personal_fouls      
    remove_column :scorecards, :started             
  end

  def down
  end
end
