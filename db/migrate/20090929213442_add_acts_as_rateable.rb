class AddActsAsRateable < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      
      t.integer     :rating,            :default => 0
      
      t.integer     :user_id
      t.integer     :rateable_id
      t.string      :rateable_type,     :limit => 15
      
      t.boolean     :archive,           :default => false
      t.datetime    :deleted_at
      
      t.timestamps
      
    end

    add_index :ratings, :user_id, :name => 'fk_ratings_user'
  end

  def self.down
    drop_table :ratings
  end
end