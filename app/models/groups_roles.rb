class GroupsRoles < ActiveRecord::Base

  set_primary_keys :group_id, :role_id 

  # remove all groups_roles not in roles
  def self.remove_groups_roles
    find(:all, :conditions => "role_id not in (select id from roles)").each do |role|
      role.destroy
    end
  end
end
