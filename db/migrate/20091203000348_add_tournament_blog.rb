class AddTournamentBlog < ActiveRecord::Migration
  def self.up
    add_column      :blogs,         :tournament_id,     :integer
    add_column      :entries,       :tournament_id,     :integer
    add_column      :comments,      :tournament_id,     :integer
  end

  def self.down
    remove_column   :blogs,         :tournament_id
    remove_column   :entries,       :tournament_id
    remove_column   :comments,      :tournament_id
  end
end
