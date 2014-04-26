class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.string :message
      t.integer :user_id
      t.integer :schedule_id
      t.datetime :date

      t.timestamps
    end
  end
end
