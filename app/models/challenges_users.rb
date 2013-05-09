# == Schema Information
#
# Table name: challenges_users
#
#  challenge_id :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  archive      :boolean          default(FALSE)
#

class ChallengesUsers < ActiveRecord::Base
	set_primary_keys =:user_id, :challenge_id 

  # record a challenge join
  def self.join_item(user, challenge)
    self.create!(:challenge_id => challenge.id, :user_id => user.id, :created_at => Time.now, :updated_at => Time.now) if self.exists?(user, challenge)
  end  

  def self.leave_item(user, challenge) 
    connection.delete("DELETE FROM challenges_users WHERE challenge_id = #{challenge.id} and user_id = #{user.id} ")
  end

  # Return true if the user challenge nil
  def self.exists?(user, challenge)
    find_by_challenge_id_and_user_id(challenge, user).nil?
  end

end
