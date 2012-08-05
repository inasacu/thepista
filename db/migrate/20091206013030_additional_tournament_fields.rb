class AdditionalTournamentFields < ActiveRecord::Migration
  def self.up
    add_column      :blogs,         :tournament_id,     :integer
    add_column      :entries,       :tournament_id,     :integer
    add_column      :comments,      :tournament_id,     :integer
    add_column      :teammates,     :tournament_id,     :integer 
    
    add_column      :forums,        :meet_id,           :integer
    remove_column   :forums,        :practice_id
      
    add_index       :teammates,     :tournament_id
  end

  def self.down
  end
end
