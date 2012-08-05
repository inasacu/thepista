class AddSportPlayerLimit < ActiveRecord::Migration
  def self.up
    add_column        :sports,        :player_limit,      :integer,       :default => 150
    change_column     :groups,        :player_limit,      :integer,       :default => 150
  end

  def self.down
  end
end
