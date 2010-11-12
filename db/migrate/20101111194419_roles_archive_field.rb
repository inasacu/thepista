class RolesArchiveField < ActiveRecord::Migration
  def self.up
    add_column      :roles,         :archive,     :boolean,     :default => false
    add_column      :roles_users,   :archive,     :boolean,     :default => false
    add_column      :forums,        :archive,     :boolean,     :default => false
    add_column      :blogs,         :archive,     :boolean,     :default => false
    add_column      :comments,      :archive,     :boolean,     :default => false
    add_column      :slugs,         :archive,     :boolean,     :default => false
    
    # add indexes for archive field 
    add_index      :roles,         :archive
    add_index      :roles_users,   :archive
    add_index      :forums,        :archive
    add_index      :blogs,         :archive
    add_index      :comments,      :archive
    add_index      :slugs,         :archive
  end

  def self.down
    remove_column   :roles,         :archive
    remove_column   :roles_users,   :archive
    remove_column   :forums,        :archive
    remove_column   :blogs,         :archive
    remove_column   :comments,      :archive
    remove_column   :slugs,         :archive
  end
end
