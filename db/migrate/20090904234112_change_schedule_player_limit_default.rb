class ChangeSchedulePlayerLimitDefault < ActiveRecord::Migration
  def self.up
    change_column   :schedules,     :player_limit,    :integer,   :default => 0
    remove_column   :schedules,     :reminder_at
    add_column      :schedules,     :reminder,        :boolean,   :default => true
    
    change_column   :practices,     :player_limit,    :integer,   :default => 0
    remove_column   :practices,     :privacy
    add_column      :practices,     :public,          :boolean,     :default => true
  end
  
  def self.down
  end
end
