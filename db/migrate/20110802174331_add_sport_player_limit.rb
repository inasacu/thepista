class AddSportPlayerLimit < ActiveRecord::Migration
  def self.up
    add_column        :sports,        :player_limit,      :integer,       :default => 150
    change_column     :groups,        :player_limit,      :integer,       :default => 150
  end

  def self.down
    remove_column       :sports,        :player_limit
    change_column       :groups,        :player_limit,      :integer,       :default => 99
  end
end


# rake db:migrate VERSION=20110802174331