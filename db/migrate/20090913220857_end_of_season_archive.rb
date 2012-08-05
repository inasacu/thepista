class EndOfSeasonArchive < ActiveRecord::Migration
  def self.up
    add_column      :users,         :active,              :boolean,         :default => true
  end

  def self.down     
  end
end
