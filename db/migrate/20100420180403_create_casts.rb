class CreateCasts < ActiveRecord::Migration
  def self.up
    create_table :casts do |t|

      t.integer   :challenge_id
      t.integer   :user_id
      t.integer   :game_id

      t.integer   :home_score
      t.integer   :away_score

      t.timestamps
    end
  end

  def self.down
    drop_table :casts
  end
end
