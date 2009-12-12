class TournamentsUsers < ActiveRecord::Base

  set_primary_keys :user_id, :tournament_id 

  # record a tournament join
  def self.join_tour(user, tournament)
    self.create!(:tournament_id => tournament.id, :user_id => user.id) if self.exists?(user, tournament)
  end  

  def self.leave_tour(user, tournament) 
    connection.delete("DELETE FROM tournaments_users WHERE tournament_id = #{tournament.id} and user_id = #{user.id} ")
  end

  # Return true if the user tournament nil
  def self.exists?(user, tournament)
    find_by_tournament_id_and_user_id(tournament, user).nil?
  end

end
