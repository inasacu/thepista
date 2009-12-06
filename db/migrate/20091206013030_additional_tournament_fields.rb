class AdditionalTournamentFields < ActiveRecord::Migration
  def self.up
    add_column      :blogs,         :tournament_id,     :integer
    add_column      :entries,       :tournament_id,     :integer
    add_column      :comments,      :tournament_id,     :integer
    add_column      :teammates,     :tournament_id,     :integer 

    add_index       :teammates,     :tournament_id
  end

  def self.down
    remove_column   :blogs,         :tournament_id
    remove_column   :entries,       :tournament_id
    remove_column   :comments,      :tournament_id
    remove_column   :teammates,     :tournament_id
  end
end
