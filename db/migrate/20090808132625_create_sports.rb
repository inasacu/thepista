class CreateSports < ActiveRecord::Migration

  def self.up
    create_table :sports do |t|
      t.string      :name,                  :limit => 50
      t.text        :description
      t.string      :icon,                  :limit => 40
      
      t.float       :points_for_win,        :default => 3
      t.float       :points_for_lose,       :default => 0
      t.float       :points_for_draw,       :default => 1
      t.datetime    :deleted_at
      t.timestamps
    end

    # [[1,'Futbol 7','futbol.gif'],
    #   [2,'Futbol 11','futbol.gif'],
    #   [3,'FutSal','futbol.gif'],
    #   [4,'Football','futbol.gif'],
    #   [5,'Soccer','futbol.gif'],
    #   [6,'Golf','golf.gif'],
    #   [7,'Basketball','basketball.gif'],
    #   [8,'Volleyball','futbol.gif'],
    #   [9,'Tennis','tennis.gif'],
    #   [10,'Hockey','futbol.gif'],
    #   [99999,'Other','futbol.gif']].each do |sport|
    #     Sport.create(:id => sport[0], :name => sport[1],  :icon => sport[2])
    end
    
    
    # update sports set id = 99999 where id = 161
    # update schedules set sport_id = activity_id
    # update groups set sport_id = activity_id
    
  end

  def self.down
    drop_table :sports
  end
end

