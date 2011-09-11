class AddHolidayIndex < ActiveRecord::Migration
  def self.up
    add_index         :holidays,        :type_id
  end

  def self.down
  end
end
