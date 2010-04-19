class CreatePreditions < ActiveRecord::Migration
  def self.up
    create_table :preditions do |t|

      t.integer   :porra_id
      t.integer   :user_id
      t.integer   :game_id

      t.integer   :home_score
      t.integer   :away_score

      t.timestamps
    end
  end

  def self.down
    drop_table :preditions
  end
end
