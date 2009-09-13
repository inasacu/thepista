class EndOfSeasonArchive < ActiveRecord::Migration
  def self.up
    add_column      :schedules,     :season_ends_at,      :datetime
    add_column      :scorecards,    :season_ends_at,      :datetime
    
    add_column      :users,         :active,              :boolean,         :default => true
  end

  def self.down
    remove_column   :schedules,     :season_ends_at
    remove_column   :scorecards,    :season_ends_at
    
    remove_column   :users,         :active    
  end
end
