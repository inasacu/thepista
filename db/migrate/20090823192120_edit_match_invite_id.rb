class EditMatchInviteId < ActiveRecord::Migration
  def self.up
    change_column   :matches,   :invite_id,   :integer,   :default => 0
    change_column   :scorecards,  :points,    :float,     :default => 0.0
  end

  def self.down
    change_column   :matches,   :invite_id,   :integer,   :default => 0
    change_column   :scorecards,  :points,    :float,     :default => 0.0
  end
end
