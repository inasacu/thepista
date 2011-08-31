class CreateTimetables < ActiveRecord::Migration
  def self.up
    create_table :timetables do |t|

  		t.string        :day_of_week
  		t.integer       :installation_id
  		t.integer       :type_id
  		t.datetime      :starts_at
  		t.datetime      :ends_at
  		t.float         :timeframe,				        :default => 1.0
  		t.boolean       :archive,				          :default => false
  		t.timestamps
  		
    end
      add_index         :timetables,       :installation_id
      add_index         :timetables,       :type_id
  end

  def self.down
    drop_table :timetables
  end
end
