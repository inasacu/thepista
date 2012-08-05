class RemoveTableUnneededFields < ActiveRecord::Migration
  def self.up
    remove_column   :blogs,         :tournament_id
    remove_column   :comments,      :tournament_id
    remove_column   :teammates,     :tournament_id
    remove_column   :forums,        :meet_id
  end

  def self.down
  end
end
