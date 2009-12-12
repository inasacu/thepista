class RolesUsers < ActiveRecord::Base

  set_primary_keys :user_id, :role_id 

  # remove all roles_users not in roles
  def self.remove_roles_users
    find(:all, :conditions => "role_id not in (select id from roles)").each do |role|
      role.destroy
    end
  end

  def self.find_team_manager(group)
    find(:first, 
    :conditions => ["role_id in " +
      "(select id from roles " +
      "where roles.authorizable_type = 'Group'" +
      "and roles.name = 'manager' " +
      "and roles.authorizable_id = ? )", group.id])
    end 

  def self.find_tour_manager(tournament)
    find(:first, 
    :conditions => ["role_id in " +
      "(select id from roles " +
      "where roles.authorizable_type = 'Tournament'" +
      "and roles.name = 'manager' " +
      "and roles.authorizable_id = ? )", tournament.id])
    end 
end
