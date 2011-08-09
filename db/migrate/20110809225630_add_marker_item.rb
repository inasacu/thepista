class AddMarkerItem < ActiveRecord::Migration
  def self.up
    add_column            :markers,           :item_id,            :integer
    add_column            :markers,           :item_type,          :string

    add_column            :markers,           :lat,                 :float,       :default => 0.0    
    add_column            :markers,           :lng,                 :float,       :default => 0.0

    add_index             :markers,           [:item_id, :item_type]

    Marker.find(:all).each do |marker|
      marker.lat = marker.latitude
      marker.lng = marker.longitude
      marker.save
    end

  end

  def self.down
    remove_column         :markers,           :item_id
    remove_column         :markers,           :item_type

    remove_column         :markers,           :lat
    remove_column         :markers,           :lng
  end
end

