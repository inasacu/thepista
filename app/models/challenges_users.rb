class ChallengesUsers < ActiveRecord::Base
  set_primary_keys :user_id, :challenge_id 

  # record a challenge join
  def self.join_team(user, challenge)
    self.create!(:challenge_id => challenge.id, :user_id => user.id) if self.exists?(user, challenge)
  end  

  def self.leave_team(user, challenge) 
    connection.delete("DELETE FROM challenges_users WHERE challenge_id = #{challenge.id} and user_id = #{user.id} ")
  end

  # Return true if the user challenge nil
  def self.exists?(user, challenge)
    find_by_challenge_id_and_user_id(challenge, user).nil?
  end

end
