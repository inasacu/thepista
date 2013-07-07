# == Schema Information
#
# Table name: roles_users
#
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :boolean          default(FALSE)
#

class RolesUsers < ActiveRecord::Base
  set_primary_keys = :user_id, :role_id 

  # remove all roles_users not in roles
  def self.remove_roles_users
    find(:all, :conditions => "role_id not in (select id from roles)").each do |role|
      role.destroy
    end
  end

  def self.find_item_manager(item)
    find(:first, 
    :conditions => ["role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'manager')", 
      item.id, item.class.to_s])
  end

  def self.find_all_item_managers(item)
    find(:all, 
    :conditions => ["role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'manager')", 
      item.id, item.class.to_s])
  end

  def self.find_item_creator(item)
    find(:first, 
    :conditions => ["role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'creator')", 
      item.id, item.class.to_s])
  end 
end
