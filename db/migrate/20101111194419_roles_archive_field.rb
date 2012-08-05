class RolesArchiveField < ActiveRecord::Migration
  def self.up
    add_column      :roles,         :archive,     :boolean,     :default => false
    add_column      :roles_users,   :archive,     :boolean,     :default => false
    add_column      :comments,      :archive,     :boolean,     :default => false
    
    # add indexes for archive field 
    add_index      :roles,         :archive
    add_index      :roles_users,   :archive
    add_index      :comments,      :archive
  end

  def self.down
  end
end
