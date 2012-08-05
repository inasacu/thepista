class AddMarkerItem < ActiveRecord::Migration
  def self.up
    add_column            :markers,           :item_id,            :integer
    add_column            :markers,           :item_type,          :string

    add_column            :markers,           :lat,                 :float,       :default => 0.0    
    add_column            :markers,           :lng,                 :float,       :default => 0.0

    add_index             :markers,           [:item_id, :item_type]
  end

  def self.down
  end
end

