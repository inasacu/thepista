class AddRatingAverageToUser < ActiveRecord::Migration
  def self.up
    add_column :matches, :rating_average_technical, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :matches, :rating_average_physical, :decimal, :default => 0, :precision => 6, :scale => 2
  end

  def self.down
    remove_column :matches, :rating_average_technical
    remove_column :matches, :rating_average_physical
  end
end