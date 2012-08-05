class AddHolidayRegionType < ActiveRecord::Migration
  def self.up
    add_column        :holidays,        :type_id,       :integer
    
    add_index         :holidays,        :venue_id
  end

  def self.down
  end
end
