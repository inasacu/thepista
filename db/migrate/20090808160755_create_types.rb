class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
        t.string      :name,          :limit => 40
        t.string      :table_type,    :limit => 40
        t.integer     :table_id

        t.timestamps
      end    
  end

  def self.down
  end
end
