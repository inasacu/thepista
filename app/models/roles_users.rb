class RolesUsers < ActiveRecord::Base

  self.primary_keys = :user_id, :role_id 

  # remove all roles_users not in roles
  def self.remove_roles_users
    find.where("role_id not in (select id from roles)").each do |role|
      role.destroy
    end
  end

  def self.find_item_manager(item)
    find.where("role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'manager')", item.id, item.class.to_s).first()
  end

  def self.find_all_item_managers(item)
    find.where("role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'manager')", item.id, item.class.to_s)
  end

  def self.find_item_creator(item)
    find.where("role_id in (select id from roles where roles.authorizable_id = ? and roles.authorizable_type = ? and roles.name = 'creator')", item.id, item.class.to_s).first()
  end  
end
