class CreateFirstGames < ActiveRecord::Migration
  def self.up
    create_table :first_games do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :first_games
  end
end
