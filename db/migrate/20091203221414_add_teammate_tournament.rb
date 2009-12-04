class AddTeammateTournament < ActiveRecord::Migration
  def self.up
    add_column          :teammates,         :tournament_id,     :integer 
    
    add_index           :teammates,         :tournament_id  
  end

  def self.down
    remove_column       :teammates,         :tournament_id
  end
end