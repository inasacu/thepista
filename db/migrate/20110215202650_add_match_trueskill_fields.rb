class AddMatchTrueskillFields < ActiveRecord::Migration
  def self.up
    add_column    :matches,     :initial_mean,        :float,     :default => 0.0
    add_column    :matches,     :initial_deviation,   :float,     :default => 0.0
    add_column    :matches,     :final_mean,          :float,     :default => 0.0
    add_column    :matches,     :final_deviation,     :float,     :default => 0.0
    add_column    :matches,     :game_number,         :integer,   :default => 0    
  end

  def self.down
    remove_column    :matches,     :initial_mean
    remove_column    :matches,     :initial_deviation
    remove_column    :matches,     :final_mean
    remove_column    :matches,     :final_deviation
    remove_column    :matches,     :game_number
  end
end
