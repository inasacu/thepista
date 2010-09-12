class GroupsUsers < ActiveRecord::Base

  set_primary_keys :user_id, :group_id 
  
  # record a group join
  def self.join_team(user, group)
    self.create!(:group_id => group.id, :user_id => user.id, :created_at => Time.now, :updated_at => Time.now) if self.exists?(user, group)
  end  

  def self.leave_team(user, group) 
    connection.delete("DELETE FROM groups_users WHERE group_id = #{group.id} and user_id = #{user.id} ")
  end

  # Return true if the user group nil
  def self.exists?(user, group)
    find_by_group_id_and_user_id(group, user).nil?
  end

end