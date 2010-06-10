class AddGamePoints < ActiveRecord::Migration

  def self.up
    add_column  :games,       :points_for_draw,               :integer,           :default => 0
    add_column  :games,       :points_for_goal_difference,    :integer,           :default => 0
    add_column  :games,       :points_for_goal_total,         :integer,           :default => 0
    add_column  :games,       :points_for_winner,             :integer,           :default => 0
  end

  def self.down
    remove_column  :games,       :points_for_draw
    remove_column  :games,       :points_for_goal_difference
    remove_column  :games,       :points_for_goal_total
    remove_column  :games,       :points_for_winner
  end
end


