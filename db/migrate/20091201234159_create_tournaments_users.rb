class CreateTournamentsUsers < ActiveRecord::Migration
  def self.up
    create_table :tournaments_users do |t|
      t.integer     :tournament_id
      t.integer     :user_id      
      t.datetime    :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments_users
  end
end
