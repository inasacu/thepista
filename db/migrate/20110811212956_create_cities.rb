class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string        :name
      t.integer       :state_id,        :default => 1
      t.boolean       :archive,         :default => false
      t.timestamps
    end
  end

  def self.down
  end
end
