class AddMatchMoral < ActiveRecord::Migration
  def self.up    
    add_column        :matches,         :moral,                     :integer,             :default => 3
    add_column        :matches,         :rating_average_moral,      :decimal,             :default => 0,      :precision => 6,        :scale => 2
  end

  def self.down
  end
end
