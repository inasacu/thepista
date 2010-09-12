class DropUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :activity_stream_preferences
    drop_table :activity_stream_totals
    drop_table :activity_streams
    
    drop_table :feeds
    drop_table :entries
    drop_table :posts
    drop_table :practice_attendees
    drop_table :practices
    drop_table :tournaments
    drop_table :tournaments_users
    drop_table :meets
    drop_table :clashes  
    drop_table :topics
    drop_table :rounds  
  end

  def self.down
  end
end
