class CreateSubsequentGames < ActiveRecord::Migration
  def self.up
    create_table :subsequent_games do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :subsequent_games
  end
end
