class ChangeSchedulePlayerLimitDefault < ActiveRecord::Migration
  def self.up
    change_column   :schedules,     :player_limit,    :integer,   :default => 0
    remove_column   :schedules,     :reminder_at
    add_column      :schedules,     :reminder,        :boolean,   :default => true
    
    change_column   :practices,     :player_limit,    :integer,   :default => 0
    remove_column   :practices,     :privacy
    add_column      :practices,     :public,          :boolean,     :default => true
  end
  
  Schedule.where("player_limit is null").each do |schedule|
    schedule.player_limit = 0
    schedule.description = 'no hay detalles' if schedule.description.blank? or schedule.description.empty?
    schedule.save!
  end

  Practice.where("player_limit is null").each do |practice|
    practice.player_limit = 0
    practice.description = 'no hay detalles' if practice.description.blank? or practice.description.empty?
    practice.save!
  end
  
  def self.down
    change_column   :schedules,     :player_limit,      :integer
    add_column      :schedules,     :reminder_at,       :datetime
    remove_column   :schedules,     :reminder
    
    change_column   :practices,     :player_limit,      :integer
    remove_column   :practices,     :public
    add_column      :practices,     :privacy,           :boolean,     :default => true
  end
end
