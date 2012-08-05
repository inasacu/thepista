class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|

      t.string      :name
      t.integer     :venue_id
      t.datetime    :starts_at
      t.datetime    :ends_at
      t.boolean     :holiday_hour,    :default => true
      t.boolean     :archive,         :default => false
      t.timestamps
      
    end
    add_index       :holidays,        :venue_id

  end

  def self.down
  end
end
