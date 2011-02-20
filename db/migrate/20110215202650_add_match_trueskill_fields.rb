class AddMatchTrueskillFields < ActiveRecord::Migration
  def self.up
    add_column    :matches,     :mean_skill,        :float,     :default => 0.0
    add_column    :matches,     :skill_deviation,   :float,     :default => 0.0
    add_column    :matches,     :game_number,       :integer,   :default => 0    
  end

  def self.down
    remove_column    :matches,     :mean_skill
    remove_column    :matches,     :skill_deviation
    remove_column    :matches,     :game_number
  end
end
