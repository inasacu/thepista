# == Schema Information
#
# Table name: groups_roles
#
#  group_id   :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :boolean          default(FALSE)
#

class GroupsRoles < ActiveRecord::Base

  set_primary_keys =:group_id, :role_id 

  # remove all groups_roles not in roles
  def self.remove_groups_roles
    find.where("role_id not in (select id from roles)").each do |role|
      role.destroy
    end
  end
end
