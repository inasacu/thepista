class RolesArchiveField < ActiveRecord::Migration
  def self.up
    add_column      :roles,         :archive,     :boolean,     :default => false
    add_column      :roles_users,   :archive,     :boolean,     :default => false
    add_column      :forums,        :archive,     :boolean,     :default => false
    add_column      :blogs,         :archive,     :boolean,     :default => false
    add_column      :comments,      :archive,     :boolean,     :default => false
  end

  def self.down
    remove_column   :roles,         :archive
    remove_column   :roles_users,   :archive
    remove_column   :forums,        :archive
    remove_column   :blogs,         :archive
    remove_column   :comments,      :archive
  end
end
