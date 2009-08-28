class CreatePracticeAttendees < ActiveRecord::Migration
  def self.up
    create_table :practice_attendees do |t|
      t.integer       :group_id
      t.integer       :user_id
      t.integer       :practice_id
      
      t.datetime      :deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :practice_attendees
  end
end
